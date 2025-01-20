# ใช้ Node.js image ที่รองรับการทำงานกับ TypeScript
FROM node:18-alpine

# กำหนด working directory ใน Docker container
WORKDIR /usr/src/app

# คัดลอก package.json และ package-lock.json
COPY package*.json ./

# ติดตั้ง dependencies
RUN npm install

# คัดลอกไฟล์ source code ไปยัง container
COPY . .

# คอมไพล์ TypeScript (หากต้องการ)
RUN npm run build

# ตั้งค่าพอร์ตที่ container จะฟัง
EXPOSE 3000

# รันคำสั่งเพื่อเริ่มต้นโปรเจค
CMD ["npm", "run", "dev"]
