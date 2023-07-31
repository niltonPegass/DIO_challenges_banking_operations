--  RESPONDENDO PERGUNTAS COM QUERIES SQL  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

USE ECOMMERCE;
SHOW TABLES;

-- -- -- -- -- -- -- -- -- -- -- -- -- --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- RECUPERANDO A QUANTIDADE (POR CLIENTE) DE PRODUTOS DENTRO DE UM MESMO PEDIDO AGRUPANDO DIVERSOS
-- PRODUTOS EM UM MESMO "ID" DE PEDIDO E ORDENANDO PELA QUANTIDADE DE ITENS EM ORDEM DESCENDENTE
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- POSSÍVEL AVALIAR OS CLIENTES QUE COLOCAM MAIS PRODUTOS DENTRO DE UM ÚNICO PEDIDO E AVALIAR DESCONTOS
-- PERSONALIZADOS PARA FRETES.
-- POSSÍVEL OBTER INSIGHTS SOBRE REGIÕES DO PAÍS ONDE OS CLIENTES MAIS ADICIONAM PRODUTOS DENTRO
-- DE UM ÚNICO PEDIDO. REPENSAR POLÍTICAS DE PREÇO PARA FRETES (OU DE DESCONTOS EM PRODUTOS PARA REGIÕES)
SELECT 
    CONCAT(FNAME, ' ', LNAME) AS CLIENT,
    COUNT(O.ID_ORDER) AS QTD_ITENS
FROM CLIENTS C
        INNER JOIN ORDERS O ON C.ID_CLIENT = O.ID_CLIENT
        INNER JOIN PRODUCT_ORDER P ON O.ID_ORDER = P.ID_POORDER
GROUP BY O.ID_ORDER
ORDER BY QTD_ITENS DESC;

-- QUERIES AUXILIARES DA CONSULTA ACIMA
SELECT * FROM ORDERS;
SELECT * FROM PRODUCT_ORDER;
SELECT * FROM CLIENTS;

-- -- -- -- -- -- -- -- -- -- -- -- -- --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- RECUPERANDO OS PRODUTOS E SUAS CATEGORIAS QUE TEM O PREÇO MAIOR OU IGUAL A $250
-- E QUAIS SUAS RESPECTIVAS NOTAS
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- POSSÍVEL AVALIAR POR FAIXA DE PREÇOS COMO ESTÃO AS CLASSIFICAÇÕES DOS PRODUTOS
-- POSSÍVEL AVALIAR QUAIS CATEGORIAS MAIS SE ENCONTRAM EM DETERMINADA FAIXA DE PREÇOS
SELECT 
    PR.PNAME AS PRODUCT,
    CATEGORY,
    PRICE,
    RATING
FROM PRODUCTS PR
        INNER JOIN PRODUCT_BATCH PB ON PR.ID_PRODUCT = PB.ID_PRODUCT
        INNER JOIN BATCH BA ON PB.ID_BATCH = BA.ID_BATCH
HAVING PRICE >= 250
ORDER BY PR.PRICE DESC;

SELECT 
    PR.ID_PRODUCT, PR.PNAME AS PRODUCT, BA.BATCH_NUMBER
FROM
    PRODUCTS PR,
    BATCH BA,
    PRODUCT_BATCH PB
WHERE
    PR.ID_PRODUCT = PB.ID_PRODUCT
        AND PB.ID_BATCH = BA.ID_BATCH
ORDER BY BATCH_NUMBER;

-- QUERIES AUXILIARES DA CONSULTA ACIMA
SELECT * FROM BATCH AS BA;
SELECT * FROM PRODUCT_BATCH AS PB;
SELECT * FROM PRODUCTS AS PR;

-- -- -- -- -- -- -- -- -- -- -- -- -- --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- RECUPERANDO QUAIS PEDIDOS FORAM FEITOS COM CARTÕES DE CRÉDITO,
-- QUAIS FORAM OS CLIENTES E QUAL A BANDEIRA DOS CARTÕES
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- POSSÍVEL AVALIAR QUAIS SÃO OS MAIORES COMPRADORES E QUAL MÉTODO PRINCIPAL DE PAGAMENTO
-- POSSÍVEL AVALIAR QUAL BANDEIRA DE CARTÃO É MAIS UTILIZADA E PENSAR EM POLÍTICAS DE PREÇOS
-- PARA DETERMINADAS BANDEIRAS DE CARTÕES (OU SE CONTINUARÁ SENDO PERMITIDA A UTILIZAÇÃO
-- DAQUELA BANDEIRA NO E-COMMERCE).

SELECT 
    PA.ID_PAYMENT_CASH AS NBOLETO,
    C2.ID_CREDIT_CARD AS ID_CARD,
    C2.CARDHOLDER_NAME,
    C2.FLAG
FROM PAYMENTS AS PA
        LEFT JOIN PAYMENT_CREDIT_CARD AS PC ON PA.ID_ORDER = PC.ID_ORDER
        LEFT JOIN CREDIT_CARD AS C2 ON PC.ID_CREDIT_CARD = C2.ID_CREDIT_CARD
HAVING PA.ID_PAYMENT_CASH = 6
	AND C2.ID_CREDIT_CARD != 5;
	-- [!] COMO SGBD NÃO ACEITA CHAVES ESTRANGEIRAS NULAS "CREDIT CARD = 5" FOI CRIADO PARA SERVIR
    -- [!] DE CHAVE ESTRANGEIRA NULA E "PAYMENT_CASH = 6" FOI CRIADO PARA A MESMA FINALIDADE

-- QUERIES AUXILIARES DA CONSULTA ACIMA
SELECT * FROM PAYMENTS AS PA;
SELECT * FROM PAYMENT_CREDIT_CARD AS PC;
SELECT * FROM CREDIT_CARD AS C2;
    
-- -- -- -- -- -- -- -- -- -- -- -- -- --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --