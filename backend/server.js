import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { GoogleGenAI } from "@google/genai";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json({ limit: "10mb" }));

const ai = new GoogleGenAI({
    apiKey: process.env.GEMINI_API_KEY
});

app.get("/", (req, res) => {
    res.send("AI Smart Farming Backend Running!");
});

app.post("/analyze", async (req, res) => {
    try {
        const {
            farmerData,
            currentLocation,
            weatherData,
            soilImage,
            soilImageMimeType,
            language
        } = req.body;

        const selectedLanguage =
            language === "Hindi" ? "Hindi" : "English";

        const languageInstruction =
            selectedLanguage === "Hindi"
                ? "Write all values in simple Hindi."
                : "Write all values in simple English.";

        const prompt = `
You are an expert agricultural AI assistant.

${languageInstruction}

Analyze the farmer information:

Farmer Details: ${JSON.stringify(farmerData)}
Location: ${currentLocation}
Weather: ${JSON.stringify(weatherData)}

IMPORTANT LOCATION RULES:

- This application is designed for Indian farmers.
- Treat the farming context as India.
- Use the farmer's supplied location exactly.
- If GPS coordinates are supplied, do not guess the
  village, district or state.
- Never invent a location.
- Base crop recommendations on Indian agricultural
  conditions and Indian farming practices.
- Do not use US farming conditions or US market data.

Recommend exactly 5 suitable crops.

Return ONLY valid JSON. Do not use markdown or code fences.

Use this exact JSON structure:

{
  "crops": [
    {
      "name": "Crop name",
      "reason": "Why suitable",
      "season": "Growing season",
      "soil": "Soil requirements",
      "water": "Water requirements",
      "fertilizer": "Fertilizer recommendations",
      "duration": "Growing duration",
      "harvesting": "Harvesting information",
      "precautions": "Important precautions",
      "expectedYield": "Estimated yield with units"
    }
  ]
}

Important:
- Return exactly 5 crops.
- Keep all keys in English.
- Write values in the selected language.
- Do not invent soil test results.
- Fertilizer advice must be based on available information.
- Clearly identify estimated yield.
- Mention that soil laboratory testing is needed
  for accurate nutrient and pH assessment.
`;

        const contents = [
            {
                text: prompt
            }
        ];

        if (soilImage) {
            contents.push({
                inlineData: {
                    mimeType: soilImageMimeType || "image/jpeg",
                    data: soilImage
                }
            });
        }

        const response = await ai.models.generateContent({
            model: "gemini-3.5-flash-lite",
            contents: contents
        });

        // Convert AI response into JSON
        let aiText = response.text.trim();

        aiText = aiText
            .replace(/^```json\s*/i, "")
            .replace(/^```\s*/, "")
            .replace(/\s*```$/, "");

        const start = aiText.indexOf("{");
        const end = aiText.lastIndexOf("}");

        if (start === -1 || end === -1) {
            throw new Error("Invalid AI JSON response");
        }

        const analysis = JSON.parse(
            aiText.substring(start, end + 1)
        );

        if (!Array.isArray(analysis.crops)) {
            throw new Error("Crop data missing");
        }

        res.json({
            success: true,
            crops: analysis.crops
        });

    } catch (error) {
        console.error("Gemini Error:", error);

        res.status(500).json({
            success: false,
            message: "AI analysis failed."
        });
    }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on port ${PORT}`);
});