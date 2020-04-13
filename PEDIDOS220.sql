SELECT 
     F.CODFORNEC
    ,F.FORNECEDOR
    ,F.CODPROD
    ,F.DESCRICAO
    ,F.CODFAB
    ,SUM(F.QTPALMAS) QTPALMAS
    ,SUM(F.QTMARABA) QTMARABA
    ,SUM(F.QTTERESINA) QTTERESINA
    ,SUM(F.QTMARANHAO) QTMARANHAO
    ,SUM(F.QTCABEDELO) QTCABEDELO
    ,SUM(F.QTCASTANHAL) QTCASTANHAL
FROM 
(SELECT 
     PCPEDIDO.CODFORNEC
    ,PCFORNEC.FORNECEDOR
    ,PCFORNEC.CGC 
    ,PCPEDIDO.NUMPED
    ,PCFILIAL.CODIGO
    ,PCFILIAL.RAZAOSOCIAL
    ,PCITEM.CODPROD
    ,PCPRODUT.DESCRICAO
    ,PCPRODUT.CODFAB
    ,ROUND(NVL(PCITEM.PLIQUIDO, 0),2) PLIQUIDO
    ,case when PCPEDIDO.CODFILIAL = '1' THEN NVL(PCITEM.QTPEDIDA,0) ELSE 0 END QTPALMAS
    ,case when PCPEDIDO.CODFILIAL = '3' THEN NVL(PCITEM.QTPEDIDA,0) ELSE 0 END QTMARABA
    ,case when PCPEDIDO.CODFILIAL = '5' THEN NVL(PCITEM.QTPEDIDA,0) ELSE 0 END QTTERESINA
    ,case when PCPEDIDO.CODFILIAL = '6' THEN NVL(PCITEM.QTPEDIDA,0) ELSE 0 END QTMARANHAO
    ,case when PCPEDIDO.CODFILIAL = '7' THEN NVL(PCITEM.QTPEDIDA,0) ELSE 0 END QTCABEDELO
    ,case when PCPEDIDO.CODFILIAL = '8' THEN NVL(PCITEM.QTPEDIDA,0) ELSE 0 END QTCASTANHAL
FROM 
     PCPEDIDO
    ,PCITEM 
    ,PCPRODUT
    ,PCFORNEC
    ,PCFILIAL
    ,PCAGENDAPEDCOMPRAI                                                                                                               
    ,PCAGENDAPEDCOMPRAC 
WHERE PCPEDIDO.NUMPED = PCITEM.NUMPED
AND PCPRODUT.CODPROD = PCITEM.CODPROD
AND PCFORNEC.CODFORNEC = PCPEDIDO.CODFORNEC
AND PCFILIAL.CODIGO = PCPEDIDO.CODFILIAL
AND PCPEDIDO.DTEMISSAO BETWEEN TO_DATE('01/04/2020','DD/MM/YYYY') AND TO_DATE('13/04/2020','DD/MM/YYYY')

AND PCPEDIDO.NUMPED = PCAGENDAPEDCOMPRAI.NUMPED(+)                                                                                   
AND PCAGENDAPEDCOMPRAI.ID = PCAGENDAPEDCOMPRAC.ID(+)
AND PCFORNEC.CGC NOT IN ( 
    '04.677.096/0001-88'
    ,'10.514.737/0001-86'
    ,'11.726.695/0001-00'
    ,'07.854.673/0001-58'
    ,'04.677.096/0003-40'
    ,'10.594.434/0001-10'
    ,'07.238.005/0001-04'
    ,'30.729.072/0001-35'
    ,'04.677.096/0001-88'
)
AND NVL(REGEXP_REPLACE(PCPEDIDO.ROTINALANC, '[^0-9]'), '220') IN ('220', '245', '1301')
AND PCFORNEC.codfornec = 8289
) F
GROUP BY 
     F.CODFORNEC
    ,F.FORNECEDOR
    ,F.CODPROD
    ,F.DESCRICAO
    ,F.CODFAB
