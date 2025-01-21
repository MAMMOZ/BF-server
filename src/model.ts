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
  const summary = {
    serven: 0,
    god: 0,
    cdk: 0,
    sa: 0,
    mirror: 0,
    valkyrie: 0,
    door: 0,
    heart: 0,
    sg: 0,
    moji: 0,
    dragon: 0,
    mammoz: 0,
    kiserni: 0,
    tiger: 0,
    yeti: 0,
    gas: 0,
  };
  for (const item of data) {
    if (item.type.includes("GOD")) summary.god++;
    if (item.type.includes("CDK")) summary.cdk++;
    if (item.type.includes("SA")) summary.sa++;
    if (item.mirror) summary.mirror++;
    if (item.valk) summary.valkyrie++;
    if (item.unlockDoor) summary.door++;
    if (item.type.includes("Heart")) summary.heart++;
    if (item.type.includes("SG")) summary.sg++;
    if (item.fruit === "Dough") summary.moji++;
    if (item.fruit === "Dragon") summary.dragon++;
    if (item.fruit === "Mammoz") summary.mammoz++;
    if (item.fruit === "kiserni") summary.kiserni++;
    if (item.fruit === "Tiger") summary.tiger++;
    if (item.fruit === "Yeti") summary.yeti++;
    if (item.fruit === "Gas") summary.gas++;
  }
  return {
    data: data,
    summary: summary
  };
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
