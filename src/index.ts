import { Elysia } from "elysia";
import { swagger } from "@elysiajs/swagger";
import { cors } from '@elysiajs/cors'
import { bot, addOrUpdateBot } from "./model";
import { login } from "./login";
import { initDatabaseConnection } from "./db";

await initDatabaseConnection()

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

app.post("/bot", async ({ body }) => {
  if (!body) return { error: "No data provided" };

  try {
    const res = await bot(body);
    return res;
  } catch (error) {
    console.error("Error in /addbot:", error);
    return { error: "Failed to process data." };
  }
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

app.post("/login", async ({ body }) => {
  if (!body) return { error: "No data provided" };

  try {
    const token = await login(body);
    return { token:token, message: "Data processed successfully." };
  } catch (error) {
    console.error("Error in /addbot:", error);
    return { error: "Failed to process data." };
  }
});

app.listen(3000);

console.log(
  `🦊 Elysia is running at http://${app.server?.hostname}:${app.server?.port}/docs`
);
