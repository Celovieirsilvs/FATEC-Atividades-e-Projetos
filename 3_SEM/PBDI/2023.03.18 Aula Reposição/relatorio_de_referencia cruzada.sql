CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM pg_extension;

CREATE TABLE tb_nota(
	cod_nota SERIAL PRIMARY KEY,
	nome_aluno VARCHAR(200),
	disciplina VARCHAR(200),
	nota NUMERIC(10,2),
	data_obtencao DATE
);

INSERT INTO tb_nota(nome_aluno, disciplina, nota, data_obtencao )VALUES
('Ana', 'Matemática', 9, '2020-01-02'),
('Ana', 'Inglês', 10, '2020-02-02'),
('Ana', 'Biologia', 8, '2020-03-02'),
('Ana','História', 10,'2020-04-02'),
('João','Matemática',7,'2020-01-02'),
('João','Inglês',10,'2020-02-02'),
('João','Biologia',5,'2020-03-02'),
('João','História',7,'2020-04-02');

SELECT * FROM tb_nota;

SELECT * FROM crosstab(
	'
			SELECT
				-- uma linha por nome de aluno 
				nome_aluno,
				-- uma coluna por disciplina 
				disciplina,
				-- 
				nota
			FROM
				tb_nota
			ORDER BY nome_aluno, disciplina;
	'
)AS tb_ref_cruzada
(
	nome VARCHAR(200),
	biologia NUMERIC(10,2),
	historia NUMERIC(10,2),
	ingles NUMERIC(10,2),
	matematica NUMERIC(10,2)
);
SELECT * FROM crosstab(
		'
		SELECT
			 location,
			 year,
			 SUM(raindays)::INT
		FROM rainfalls
		GROUP BY location, year
		ORDER BY location, year;	
		'
)AS tab_rainy_days(
	"location" TEXT,
	"2012" INT,
	"2013" INT,
	"2014" INT,
	"2015" INT,
	"2016" INT,
	"2017" INT
);

--
SELECT
	 location,
	 year,
	 SUM(raindays)
FROM rainfalls
GROUP BY location, year
ORDER BY location, year;

--média de chuvas por mês
SELECT * FROM crosstab(
		'
		SELECT
			 location,
			 month,
			 AVG(raindays)::INT
		FROM rainfalls
		GROUP BY location, month
		ORDER BY location, month;	
		'
)AS tab_rainy_per_month(
	"location" TEXT,
	"jan" INT,
	"fev" INT,
	"mar" INT,
	"abr" INT,
	"mai" INT,
	"jun" INT,
	"jul" INT,
	"ago" INT,
	"set" INT,
	"out" INT,
	"nov" INT,
	"dez" INT
);

SELECT * FROM rainfalls;