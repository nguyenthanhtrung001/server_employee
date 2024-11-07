# Build stage
FROM maven:3-openjdk-17 AS build
WORKDIR /app

# Sao chép toàn bộ mã nguồn vào thư mục làm việc
COPY . .

# Build ứng dụng và bỏ qua các bài kiểm tra
RUN mvn clean package -DskipTests

# Kiểm tra thư mục target để đảm bảo file WAR đã được tạo
RUN ls -la /app/target

# Run stage
FROM openjdk:17-jdk-slim
WORKDIR /app

# Sao chép file WAR từ build stage
COPY --from=build /app/target/employee-service-0.0.1-SNAPSHOT.war drcomputer.war

# Mở cổng 8080 để truy cập ứng dụng
EXPOSE 8080

# Khởi chạy ứng dụng
ENTRYPOINT ["java", "-jar", "drcomputer.war"]
