import mysql from "mysql2/promise";

const connection = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "Cello_12345",
  database: "db_blog_app",
  port: 3306,
});

connection
  .query("SELECT 1")
  .then(() => {
    console.log("✅ MySQL berhasil terhubung!");
  })
  .catch((error) => {
    console.error("❌ MySQL gagal terhubung!");
    console.error(error);
  });

export default connection;