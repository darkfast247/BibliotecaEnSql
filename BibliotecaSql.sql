create database Biblioteca2024;

use Biblioteca2024;


-- Creación de tablas
CREATE TABLE Autores ( 
    id INT PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    nacionalidad VARCHAR(100), 
    fechaNacimiento DATE 
); 

CREATE TABLE Usuarios ( 
    id INT PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    email VARCHAR(255), 
    fechaNacimiento DATE 
); 

CREATE TABLE Editoriales ( 
    id INT PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    direccion VARCHAR(255), 
    fundacion DATE 
);
 
CREATE TABLE Categorias ( 
    id INT PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    descripcion VARCHAR(255) 
); 
 
CREATE TABLE Libros ( 
    id INT PRIMARY KEY, 
    titulo VARCHAR(255) NOT NULL, 
    autorId INT, 
    editorialId INT, 
    categoriaId INT, 
    fechaPublicacion DATE, 
    disponibilidad BIT, 
    FOREIGN KEY (autorId) REFERENCES Autores(id), 
    FOREIGN KEY (editorialId) REFERENCES Editoriales(id), 
    FOREIGN KEY (categoriaId) REFERENCES Categorias(id) 
); 

CREATE TABLE Biblioteca ( 
    id INT PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    direccion VARCHAR(255), 
    telefono VARCHAR(20), 
    fecha_Creacion DATE NOT NULL
); 

-- Insertar datos en las tablas
INSERT INTO Biblioteca (id, nombre, direccion, telefono, fecha_Creacion) 
VALUES 
    (1, 'Biblioteca Central', 'Calle Principal 123', '123-456-7890', '1990-01-01'), 
    (2, 'Biblioteca Municipal', 'Avenida Central 456', '098-765-4321', '1985-05-15');

INSERT INTO Autores (id, nombre, nacionalidad, fechaNacimiento) 
VALUES 
    (1, 'Gabriel García Márquez', 'Colombiano', '1927-03-06'), 
    (2, 'J.K. Rowling', 'Británica', '1965-07-31'), 
    (3, 'Stephen King', 'Estadounidense', '1947-09-21'); 

INSERT INTO Editoriales (id, nombre, direccion, fundacion) 
VALUES 
    (1, 'Salamandra', 'Barcelona, España', '1994-01-01'), 
    (2, 'Penguin Random House', 'New York, USA', '2013-07-01'); 

INSERT INTO Categorias (id, nombre, descripcion) 
VALUES 
    (1, 'Ficción', 'Libros de ficción'), 
    (2, 'No ficción', 'Libros de no ficción'), 
    (3, 'Fantasía', 'Libros de fantasía'), 
    (4, 'Terror', 'Libros de terror'), 
    (5, 'Drama', 'Libros de drama'); 

INSERT INTO Libros (id, titulo, autorId, editorialId, categoriaId, fechaPublicacion, disponibilidad) 
VALUES 
    (1, 'Cien años de soledad', 1, 1, 1, '1967-05-30', 1), 
    (2, 'Harry Potter y la piedra filosofal', 2, 1, 3, '1997-06-26', 1), 
    (3, 'It', 3, 2, 4, '1986-09-15', 0), -- Supongamos que este libro no está disponible
    (4, 'Crónica de una muerte anunciada', 1, 1, 1, '1981-01-01', 1), 
    (5, 'Harry Potter y la cámara secreta', 2, 1, 3, '1998-07-02', 1), 
    (6, 'Harry Potter y el prisionero de Azkaban', 2, 1, 3, '1999-07-08', 1), 
    (7, 'Carrie', 3, 2, 4, '1974-04-05', 1), 
    (8, 'The Shining', 3, 2, 4, '1977-01-28', 0), 
    (9, 'La torre oscura', 3, 2, 4, '1982-06-10', 1), 
    (10, 'Noticias del imperio', 1, 1, 1, '1986-01-01', 1), 
    (11, 'La hojarasca', 1, 1, 1, '1955-01-01', 0), 
    (12, 'El amor en los tiempos del cólera', 1, 1, 1, '1985-01-01', 1), 
    (13, 'Harry Potter y el cáliz de fuego', 2, 1, 3, '2000-07-08', 1), 
    (14, 'Harry Potter y la Orden del Fénix', 2, 1, 3, '2003-06-21', 1), 
    (15, 'Harry Potter y el misterio del príncipe', 2, 1, 3, '2005-07-16', 1);

	
DECLARE @autor_id INT;
DECLARE @categoria_id INT;

-- Set the values for the variables
SET @autor_id = 1;
SET @categoria_id = 4;

-- Consulta para obtener todos los libros de un autor específico
SELECT * 
FROM Libros 
WHERE autorId = @autor_id;

-- Consulta para obtener todos los libros de una categoría determinada
SELECT * 
FROM Libros 
WHERE categoriaId = @categoria_id;

-- Consulta para obtener todos los libros de Gabriel García Márquez, y que hayan sido publicados después de 1970
SELECT * 
FROM Libros 
WHERE autorId = 1 AND fechaPublicacion > '1970-01-01';

-- Consulta para obtener todos los libros de la categoría Terror y publicados después de 1976
SELECT * 
FROM Libros 
WHERE categoriaId = 4 AND fechaPublicacion > '1976-01-01';

-- Consulta para obtener todos los libros cuyo título contenga la palabra "Harry"
SELECT * 
FROM Libros 
WHERE titulo LIKE '%Harry%';

-- Procedimiento almacenado para calcular la cantidad de libros publicados por una editorial específica
CREATE PROCEDURE ObtenerCantidadLibrosPorEditorial
    @nombreEditorial VARCHAR(100)
AS
BEGIN
    SELECT COUNT(*) AS CantidadLibros
    FROM Libros
    WHERE editorialId = (SELECT id FROM Editoriales WHERE nombre = @nombreEditorial);
END;
GO

-- Procedimiento almacenado para devolver la lista de los libros más recientes por categoría
CREATE PROCEDURE ObtenerLibrosMasRecientesPorCategoria
    @nombreCategoria VARCHAR(100)
AS
BEGIN
    SELECT *
    FROM (
        SELECT l.*, ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY fechaPublicacion DESC) AS rn
        FROM Libros l
        JOIN Categorias c ON l.categoriaId = c.id
        WHERE c.nombre = @nombreCategoria
    ) AS Subquery
    WHERE rn = 1;
END;
GO

-- Ejecutar los procedimientos almacenados
EXEC ObtenerCantidadLibrosPorEditorial 'Salamandra';
EXEC ObtenerLibrosMasRecientesPorCategoria 'Terror';