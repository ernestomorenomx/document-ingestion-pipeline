"""
MarkItDown API Server
Recibe un archivo (PDF, DOCX, etc.) y devuelve su contenido en Markdown.
"""

from fastapi import FastAPI, UploadFile, File, HTTPException
from markitdown import MarkItDown
import tempfile
import os

app = FastAPI(
    title="MarkItDown API",
    description="Converts PDF, DOCX, and other documents to Markdown",
    version="1.0.0"
)

md = MarkItDown()


@app.get("/health")
def health_check():
    return {"status": "ok", "service": "markitdown"}


@app.post("/convert")
async def convert_document(file: UploadFile = File(...)):
    """
    Recibe un archivo y devuelve su contenido en Markdown.
    Soporta: PDF, DOCX, XLSX, PPTX, HTML, imágenes.
    """
    try:
        # Guardar archivo temporal con extensión correcta
        suffix = os.path.splitext(file.filename)[1]
        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
            content = await file.read()
            tmp.write(content)
            tmp_path = tmp.name

        # Convertir a Markdown
        result = md.convert(tmp_path)

        # Limpiar archivo temporal
        os.unlink(tmp_path)

        return {
            "filename": file.filename,
            "markdown": result.text_content,
            "status": "success"
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
