import {onRequest} from "firebase-functions/v2/https";
import {logger} from "firebase-functions";
import {Request, Response} from "express";

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = onRequest((request: Request, response: Response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.json({result: "Hello from Firebase!"});
});

// Example function for user data processing
export const processUserData = onRequest(async (request: Request, response: Response) => {
  try {
    logger.info("Processing user data", {structuredData: true});
    
    // Add your business logic here
    const result = {
      message: "User data processed successfully",
      timestamp: new Date().toISOString(),
    };
    
    response.json(result);
  } catch (error) {
    logger.error("Error processing user data:", error);
    response.status(500).json({error: "Internal server error"});
  }
});