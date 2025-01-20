import { MongoClient, Db } from "mongodb";

const uri =
  "mongodb://clm7cqub1001qbsmn1nj4ctpv:lFTpO2CZrft9yz3bNGYduxc9@161.246.127.24:9042/?readPreference=primary&ssl=false"; // เปลี่ยน URI ให้ตรงกับ MongoDB ของคุณ
const databaseName = "botDatabase"; // ชื่อ Database ที่คุณต้องการใช้

let db: Db | null = null; // ตัวแปรสำหรับเก็บ Database instance

// ฟังก์ชันเริ่มต้นเชื่อมต่อกับ MongoDB
const initDatabaseConnection = async () => {
  if (!db) {
    try {
      const client = new MongoClient(uri);
      await client.connect();
      console.log("Connected to MongoDB!");
      db = client.db(databaseName);
    } catch (error) {
      console.error("Error connecting to MongoDB:", error);
      process.exit(1); // หยุดโปรแกรมหากเชื่อมต่อไม่ได้
    }
  }
  return db;
};

// ฟังก์ชันใช้งาน MongoDB
const bot = async () => {
  if (!db) {
    throw new Error("Database not initialized");
  }
  const collection = db.collection("bots"); // เปลี่ยนชื่อ Collection ตามต้องการ
  const data = await collection.find({}).toArray();
  return data;
};

// เพิ่มหรืออัปเดตข้อมูลใน Collection
const addOrUpdateBot = async (botData: any) => {
  if (!db) {
    throw new Error("Database not initialized");
  }
  const collection = db.collection("bots");

  const query = { account: botData.account }; // เงื่อนไขการค้นหา
  const update = {
    $set: {
      ...botData,
      updatedAt: new Date(), // เวลาที่อัปเดตล่าสุด
    },
  };
  const options = { upsert: true }; // หากไม่มีเอกสารตรงกับ query จะเพิ่มใหม่

  try {
    const result = await collection.updateOne(query, update, options);
    if (result.upsertedCount > 0) {
      console.log("Data added successfully.");
    } else if (result.modifiedCount > 0) {
      console.log("Data updated successfully.");
    }
  } catch (error) {
    console.error("Error in addOrUpdateBot:", error);
  }
};

export { initDatabaseConnection, bot, addOrUpdateBot };
