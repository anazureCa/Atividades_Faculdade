--Execuções

EXEC CadastroAluno 
@N = 'Ádrian Marcos Sbardelatti',
@C = 'SDI',
@PE = 2025

EXEC CadastroCurso
@C = 'SDI',
@N = 'PROGRAMAÇÃO ORIENTADA A OBJETOS'

EXEC CadastroMateria
@S = 'POO',
@N = 'PROGRAMAÇÃO ORIENTADA A OBJETOS',
@CG = 144,
@C = 'SDI',
@P =  3

EXEC CadastroProfessor
@N = 'LUIZ MELO ROMAO'

EXEC LancarBoletim
    4, 'SDI', 'POO', 3, 2025,
    --Notas
    7,5,7,7,
    --Nota Exame
    10, 
    --Faltas
    4, 2, 24, 6;


SELECT * from ALUNOS
SELECT * from MATRICULA
SELECT * FROM MATERIAS
SELECT * FROM PROFESSOR
SELECT * FROM CURSOS

--Procedures

CREATE OR ALTER PROCEDURE CadastroAluno(@N VARCHAR(50), @C CHAR(3), @PE INT)
AS
    DECLARE @M INT;

    INSERT INTO ALUNOS (NOME)
    VALUES (@N)

    SET @M = (SELECT @@IDENTITY);

    INSERT INTO MATRICULA (MATRICULA ,CURSO, MATERIA, PROFESSOR, PERLETIVO)
    SELECT @M, M.CURSO, M.SIGLA, M.PROFESSOR, @PE
    FROM MATERIAS M
    WHERE M.CURSO = @C
GO

CREATE OR ALTER PROCEDURE CadastroMateria(@S CHAR(3), @N VARCHAR(50), @CG INT, @C CHAR(3), @P INT)
AS

    INSERT INTO MATERIAS (SIGLA, NOME, CARGAHORARIA, CURSO, PROFESSOR)
    VALUES (@S, @N, @CG, @C, @P);
GO

CREATE OR ALTER PROCEDURE CadastroCurso(@C CHAR(3), @N VARCHAR(50))
AS

    INSERT INTO CURSOS (CURSO, NOME)
    VALUES (@C, @N);
GO

CREATE OR ALTER PROCEDURE CadastroProfessor(@N VARCHAR(50))
AS

    INSERT INTO PROFESSOR (NOME)
    VALUES (@N);
GO

CREATE OR ALTER PROCEDURE LancarBoletim
    @M INT,
    @C CHAR(3),
    @MA CHAR(3),
    @P INT,
    @PE INT,
    @N1 FLOAT,
    @N2 FLOAT,
    @N3 FLOAT,
    @N4 FLOAT,
    @NE FLOAT,
    @F1 INT,
    @F2 INT,
    @F3 INT,
    @F4 INT
AS
BEGIN
    SET @M = (SELECT DISTINCT MATRICULA FROM MATRICULA WHERE MATRICULA = @M)
    IF @M IS NOT NULL
      BEGIN
        
        SET @MA = (SELECT DISTINCT MATERIA FROM MATRICULA WHERE MATERIA = @MA)
        IF @MA IS NOT NULL
            BEGIN
            UPDATE MATRICULA
            SET 
                N1 = @N1,
                N2 = @N2,
                N3 = @N3,
                N4 = @N4,
                NOTAEXAME = @NE,
                F1 = @F1,
                F2 = @F2,
                F3 = @F3,
                F4 = @F4,
                
                MEDIA = (
                    @N1 + @N2 + @N3 + @N4
                ) / 4,
                TOTALPONTOS = (
                    @N1 + @N2 + @N3 + @N4
                ),
                TOTALFALTAS = @F1 + @F2 + @F3 + @F4,
                PERCFREQ = 100 - ((@F1 + @F2 + @F3 + @F4) * 100)/144,
            RESULTADO = CASE
                WHEN (100 - ((@F1 + @F2 + @F3 + @F4) * 100)/144) < 75 
            THEN 'REPROVADO'
                WHEN  ((@N1 + @N2 + @N3 + @N4) / 4) < 3
            THEN 'REPROVADO'
                
                WHEN (100 - ((@F1 + @F2 + @F3 + @F4) * 100)/144) >= 75 AND  ((@N1 + @N2 + @N3 + @N4) / 4) > 3 AND ((@N1 + @N2 + @N3 + @N4) / 4) < 7 
            THEN 'EXAME'
                                
                WHEN (100 - ((@F1 + @F2 + @F3 + @F4) * 100)/144) >= 75 AND  ((@N1 + @N2 + @N3 + @N4) / 4) >= 7 
            THEN 'APROVADO'
            END,
            MEDIAFINAL = ((@NE + ((@N1 + @N2 + @N3 + @N4) / 4))/2)
            
            WHERE 
                MATRICULA = @M
                AND CURSO = @C
                AND MATERIA = @MA
                AND PROFESSOR = @P
                AND PERLETIVO = @PE
            END
            
        ELSE
            BEGIN
            SELECT 'Matéria não cadastrada' AS mensagem;
            END
        END
    ELSE
        BEGIN
        SELECT 'Aluno não Matriculado' AS mensagem;        
        END
        SELECT * from MATRICULA
END;


SELECT * from ALUNOS
SELECT * from MATRICULA
SELECT * FROM MATERIAS
SELECT * FROM PROFESSOR
SELECT * FROM CURSOS