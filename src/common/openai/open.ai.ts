import OpenAI from 'openai';
import { systemPrompt } from './system-prompt';
import { env } from '../../config';
const client = new OpenAI({ apiKey: env.OPENAI_KEY });

export async function ai(message: string): Promise<string> {
  try {
    const response = await client.responses.create({
      model: 'gpt-5.6-luna',
      instructions: systemPrompt,
      input: message,
    });
    return response.output_text;
  } catch (error) {
    console.error('OpenAI error:', error);
    return 'AI fix unavailable.';
  }
}
