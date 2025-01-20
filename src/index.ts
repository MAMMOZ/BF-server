import { Elysia } from "elysia";
import { swagger } from "@elysiajs/swagger";
import { cors } from '@elysiajs/cors'
import * as path from 'path';
import * as fs from 'fs';
import { initDatabaseConnection, bot, addOrUpdateBot } from "./model";
import { html } from '@elysiajs/html';



// เริ่มต้นการเชื่อมต่อ MongoDB
await initDatabaseConnection();

const app = new Elysia()
.use(
  swagger({
    documentation: {
      info: {
        title: "MAMMOZ Documentation",
        version: "1.0.0",
      },
    },
    path: "/docs",
  })
);
app.use(cors())

app.get("/bot", () => {
  return bot();
});

app.post("/addbot", async ({ body }) => {
  if (!body) return { error: "No data provided" };

  try {
    await addOrUpdateBot(body);
    return { message: "Data processed successfully." };
  } catch (error) {
    console.error("Error in /addbot:", error);
    return { error: "Failed to process data." };
  }
});

app.listen(3000);

console.log(
  `🦊 Elysia is running at http://${app.server?.hostname}:${app.server?.port}/docs`
);
