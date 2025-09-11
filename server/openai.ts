import OpenAI from 'openai';
import express from 'express';

// Initialize OpenAI client - the API key is already configured via Replit integration
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export function setupOpenAIRoutes(app: express.Express) {
  // Endpoint to generate activity description suggestions
  app.post('/api/generate-suggestions', async (req: any, res) => {
    try {
      // Check if user is authenticated
      if (!req.isAuthenticated()) {
        return res.status(401).json({ message: 'Not authenticated' });
      }

      const { activities, location, preferredTime } = req.body;

      // Build context for OpenAI
      const activitiesText = activities?.length > 0 
        ? activities.map((a: any) => a.title).join(', ')
        : 'walking and fitness activities';

      const prompt = `Generate 4 brief, engaging personal descriptions for someone interested in ${activitiesText}${location ? ` in ${location}` : ''}${preferredTime ? ` who prefers ${preferredTime}` : ''}. 
      
      Each suggestion should:
      - Be 1-2 sentences long
      - Sound personal and authentic
      - Highlight motivation or interests
      - Be suitable for a fitness/activity matching app
      
      Return only the 4 suggestions as a JSON array of strings, no other text.`;

      const completion = await openai.chat.completions.create({
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: 'You are a helpful assistant that creates engaging, personal activity descriptions for a fitness buddy matching app. Keep responses brief and authentic.'
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.8,
        max_tokens: 400,
      });

      const responseText = completion.choices[0]?.message?.content || '[]';
      
      // Try to parse the response as JSON
      let suggestions: string[];
      try {
        suggestions = JSON.parse(responseText);
        if (!Array.isArray(suggestions)) {
          throw new Error('Response is not an array');
        }
      } catch (parseError) {
        // Fallback to default suggestions if parsing fails
        console.error('Failed to parse OpenAI response:', parseError);
        suggestions = [
          'I love exploring new walking routes and discovering hidden gems in the city.',
          'Looking for motivated fitness companions who enjoy morning walks and healthy conversations.',
          'Passionate about wellness and building meaningful connections through shared activities.',
          'Training for my fitness goals and would love accountability buddies for regular activities.',
        ];
      }

      res.json({ suggestions });
    } catch (error) {
      console.error('Error generating suggestions:', error);
      
      // Return default suggestions on error
      res.json({
        suggestions: [
          'I love exploring new walking routes and discovering hidden gems in the city.',
          'Looking for motivated fitness companions who enjoy morning walks and healthy conversations.',
          'Passionate about wellness and building meaningful connections through shared activities.',
          'Training for my fitness goals and would love accountability buddies for regular activities.',
        ]
      });
    }
  });
}