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

// ฟังก์ชันดึง Database instance
const getDatabase = () => {
  if (!db) {
    throw new Error("Database not initialized");
  }
  return db;
};

export { initDatabaseConnection, getDatabase };