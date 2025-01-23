import { getDatabase } from "./db";
import jwt from "jsonwebtoken"; // สำหรับสร้าง JWT

const SECRET_KEY = "mammoz"; // เปลี่ยนเป็น key ของคุณ

// ฟังก์ชันสำหรับการ Login
const login = async (key: any) => {

  const db = getDatabase();
  const collection = db.collection("users"); // ใช้ collection ชื่อ users สำหรับเก็บข้อมูลผู้ใช้

  try {
    const user = await collection.findOne({ key:key.key });

    if (!user) {
      // หากไม่พบผู้ใช้ ให้โยน error กลับไป
      throw new Error("Invalid key or user not found");
    }

    // สร้าง payload สำหรับ JWT
    const payload = {
      id: user._id,
      key: user.key,
    };

    // สร้าง JWT token
    const token = jwt.sign(payload, SECRET_KEY, { expiresIn: "1h" });

    // ส่ง token กลับไปที่หน้าเว็บ
    return { token };
  } catch (error) {
    console.error("Error in login:", error);
    throw new Error("Login failed");
  }
};

export { login };
