import express, {
  type Express,
  type Request,
  type Response,
} from "express";
import cors from "cors";
import connection from "./db/index.ts";

const app: Express = express();

// Middleware
app.use(cors());
app.use(express.json());

// =========================
// GET SEMUA KATEGORI
// =========================
app.get("/api/categories", async (req: Request, res: Response) => {
  try {
    const [rows] = await connection.query("SELECT * FROM categories");

    res.status(200).json({
      message: "Data kategori berhasil di-fetch",
      data: rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal mengambil data kategori",
    });
  }
});

// =========================
// GET SEMUA ARTIKEL + KATEGORI
// =========================
app.get("/api/posts", async (req: Request, res: Response) => {
  try {
    const [rows] = await connection.query(`
      SELECT 
        posts.id_post,
        posts.title,
        posts.content,
        categories.name AS category,
        posts.create_at,
        posts.update_at
      FROM posts
      JOIN categories 
        ON posts.id_categories = categories.id_categories
    `);

    res.status(200).json({
      message: "Data artikel berhasil di-fetch",
      data: rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal mengambil data artikel",
    });
  }
});

// =========================
// POST TAMBAH ARTIKEL
// =========================
app.post("/api/posts", async (req: Request, res: Response) => {
  try {
    const { id_categories, title, content } = req.body;

    const [result] = await connection.query(
      `
      INSERT INTO posts (id_categories, title, content)
      VALUES (?, ?, ?)
      `,
      [id_categories, title, content]
    );

    res.status(201).json({
      message: "Artikel berhasil ditambahkan",
      data: result,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal menambahkan artikel",
    });
  }
});

// =========================
// DELETE ARTIKEL
// =========================
app.delete("/api/posts/:id", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const [result] = await connection.query(
      "DELETE FROM posts WHERE id_post = ?",
      [id]
    );

    res.status(200).json({
      message: "Artikel berhasil dihapus",
      data: result,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal menghapus artikel",
    });
  }
});
// DELETE KATEGORI
app.delete("/api/categories/:id", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const [result] = await connection.query(
      "DELETE FROM categories WHERE id_categories = ?",
      [id]
    );

    res.status(200).json({
      message: "Kategori berhasil dihapus",
      data: result,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal menghapus kategori",
    });
  }
});

// =========================
// PUT UPDATE ARTIKEL
// =========================
app.put("/api/posts/:id", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { id_categories, title, content } = req.body;

    const [result] = await connection.query(
      `
      UPDATE posts
      SET 
        id_categories = ?,
        title = ?,
        content = ?
      WHERE id_post = ?
      `,
      [id_categories, title, content, id]
    );

    res.status(200).json({
      message: "Artikel berhasil diupdate",
      data: result,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal mengupdate artikel",
    });
  }
});

// =========================
// SERVER
// =========================
app.listen(8000, () => {
  console.log("Server berjalan di http://localhost:8000");
});