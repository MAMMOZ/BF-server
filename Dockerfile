# เลือก Node.js base image
FROM node:18-alpine

# ตั้ง working directory ใน container
WORKDIR /usr/src/app

# คัดลอกไฟล์ package.json และ package-lock.json
COPY package*.json ./

# ติดตั้ง dependencies ทั้งหมด
RUN npm install

# คัดลอกโค้ดทั้งหมดไปยัง container
COPY . .

# ติดตั้ง TypeScript และ ts-node ใน container
RUN npm install -g typescript ts-node

# รันคำสั่ง ts-node เพื่อรันไฟล์ index.ts
CMD ["ts-node", "src/index.ts"]
