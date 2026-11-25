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
                 soilImageMimeType
              } = req.body;

        const prompt = `
        You are an expert agricultural AI assistant.

        Analyze the following farmer information:

        Farmer Details: ${JSON.stringify(farmerData)}
        Location: ${currentLocation}
        Weather: ${JSON.stringify(weatherData)}

        Suggest the top 5 suitable crops for this farmer.

        For each crop explain:
        1. Crop name
        2. Why it is suitable
        3. Water requirement
        4. Growing duration
        5. Important precautions

        Give practical recommendations.
        Mention that soil laboratory testing is needed
        for accurate soil nutrient and pH assessment.
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
    model: "gemini-3.8-flash",
    contents: contents
});

        res.json({
            success: true,
            analysis: response.text
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