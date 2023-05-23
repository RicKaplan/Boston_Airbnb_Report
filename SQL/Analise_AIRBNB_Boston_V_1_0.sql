-- padrão de azul #4f81bd (red=79, green=129, blue=189)
-- gráficos #bdd7ee (red=189, green=215, blue=238)
-- precisamos responder a várias perguntas a partir dos dados
-------------------------------------------------------------------------------------------------------------------------------------
-- estatística descritiva
-- Quantas propriedades foram ofertadas pelo AIRBNB de 2016 a 2017?
-- total de propriedades da amostra (2016, 2017)
   select count(distinct id) as total_propriedades  -- 3585
     from listings
-- Qual a média de preços praticada?	 
-- preço médio das listagens (preço médio ofertado)
   select avg(listings.price) as preco_medio -- 177,84
     from listings
    where bedrooms is not null
      and neighbourhood is not null	 
-- Quantos bairros foram ofertados?	 	  
-- total de bairros da amostra (2016, 2017)
   select count (distinct(neighbourhood)) as total_bairros
     from listings
    where neighbourhood is not null	 	
-- total de listagens de propriedades tivemos em 2016 e 2017, preço médio da diária e quantidade de bairros em boston
    select
        count(distinct(lis.id)) as qtd_propriedades,    -- total de listagens de propriedades
        count(distinct(lis.neighbourhood)) as qtd_bairros,   -- quantidade de bairros
        avg(cal.price) as preco_medio                   -- preço médio da diária
    from listings as lis
    join calendar as cal on listings.id=calendar.listing_id
    where lis.id is not null
      and lis.neighbourhood is not null
      and cal.price is not null	
-- Como tem evoluído o número de visitas nesses dois anos?
-- total de visitas estimadas a partir das revisões realizadas pelos hóspedes, distribuidas pelos anos
     select year(date) as ano,
           count(*) as total_visitas
     from calendar where available = FALSE
     group by ano
     order by ano
-- Qualitative analysis
-- Como os hospedes percebem a cidade de Boston?
-- Comentarios dos hospedes
      select comments
      from reviews
  
     select year(date) as ano,
           count(*) as total_visitas
     from calendar where available = FALSE
     group by ano
     order by ano
	 
-- segmentações	  
-- qual o preço médio por bairro?
-- preço médio por bairro
   select neighbourhood as bairro,
          avg(listings.price) as preco_medio
     from listings
    where neighbourhood is not null
    group by bairro
    order by preco_medio desc, bairro
-- qual o preço médio por nº de quartos?	
-- preço médio por quartos
   select bedrooms as quartos,   
          avg(listings.price) as preco_medio
     from listings
    where bedrooms is not null
    group by quartos
    order by preco_medio desc, quartos
-- qual o preço médio por bairro e nº de quartos?		
-- preço médio por bairro e por quartos
   select neighbourhood as bairro,
          bedrooms as quartos,   
          avg(listings.price) as preco_medio
     from listings
    where bedrooms is not null
      and neighbourhood is not null
    group by bairro, quartos
    order by preco_medio desc, bairro, quartos
-- quais são os bairros mais procurados?	
-- total de propriedades por bairro
    select
        neighbourhood as bairro,	
        count (distinct(id)) as total_listagens
    from 
        listings
    where neighbourhood is not null		
    group by bairro
    order by total_listagens desc
-- qual é o ranking dos 10 bairros mais procurados
-- qual é a opinião dos hospedes sobre cada bairro do ranking
-- opiniao dos hóspedes sobre cada bairro do ranking
select neighbourhood, visao_geral_do_bairro 
from listings
where neighbourhood in (
    'Allston-Brighton',
'Jamaica Plain',
'South End',
'Back Bay',
'Fenway/Kenmore',
'South Boston',
'Dorchester',
'Beacon Hill',
'North End',
'East Boston'
)
and visao_geral_do_bairro is not null and visao_geral_do_bairro != '#VALUE!'
order by neighbourhood	
-------------------------------------------------------------------------------------------------------------------------------------
-- qual o tipo de propriedade mais popular?
-- número de listagens por tipo de acomodação
    select
        room_type as tipo_acomodacao,	
        count (distinct(id)) as total_listagens
    from 
        listings
    where id is not null
      and room_type is not null            --- como o foco é a compra de imóvel "inteiro", as próximas análises 
    group by tipo_acomodacao               --- filtrarão room_type = 'Entire home/apt'
    order by total_listagens desc
-------------------------------------------------------------------------------------------------------------------------------------
--quais são os tipos de propriedades mais populares?
--total de propriedades por tipo_propriedade
    select
        property_type as tipo_propriedade,	
        count (distinct(id)) as total_listagens
    from 
        listings
    where property_type is not null 
      and id is not null
	  and room_type = 'Entire home/apt'
    group by tipo_propriedade
    order by total_listagens desc
-------------------------------------------------------------------------------------------------------------------------------------
--quais são os tipos de acomodações mais populares em função do nº de quartos?
--total de propriedades por nº de quartos
    select
        bedrooms as quartos,	
        count (distinct(id)) as total_listagens
    from 
        listings
    where bedrooms is not null 
      and id is not null
	  and room_type = 'Entire home/apt'
    group by quartos
    order by total_listagens desc
-------------------------------------------------------------------------------------------------------------------------------------
-- quais são as propriedade mais procuradas em função da quantidade de camas?
-- número de listagens por quantidade de camas
    select
        beds as qtd_camas,	
        count (distinct(id)) as total_listagens
    from 
        listings
    where id is not null
      and beds != 0
      and room_type = 'Entire home/apt'
    group by qtd_camas
    order by total_listagens desc	
-- quais são as propriedade mais procuradas em função da quantidade de hóspedes?
-- total de listagens por quantidade de hóspedes
    select
        guests_included as qtd_hospedes,	
        count (distinct(id)) as total_listagens
    from 
        listings
    where id is not null
      and guests_included != 0
    group by qtd_hospedes
    order by total_listagens desc		
-- qual a distribucao de propriedades por bairro e nº de quartos?		
-- total de propriedades por bairro e por quartos
   select neighbourhood as bairro,
          bedrooms as quartos,   
          count(distinct(id)) as total_listagens
     from listings
    where bedrooms is not null
      and neighbourhood is not null
    group by bairro, quartos
    order by total_listagens desc, bairro, quartos	
-- qual a distribucao de propriedades por bairro e tipo de acomodação?		
-- total de propriedades por bairro e por tipo de acomodação
   select neighbourhood as bairro,
          room_type as tipo_acomodacao,   
          count(distinct(id)) as total_listagens
     from listings
    where room_type is not null
      and neighbourhood is not null
    group by bairro, tipo_acomodacao
    order by total_listagens desc, bairro, tipo_acomodacao		
--- nosso foco será sempre 	room_type = "Entire home/apt" porque vamos investir em um imóvel inteiro, portanto
-- total de propriedades por bairro e imoveis inteiros
   select neighbourhood as bairro,
          room_type as tipo_acomodacao,   
          count(distinct(id)) as total_listagens
     from listings
    where room_type = 'Entire home/apt'
      and neighbourhood is not null
    group by bairro, tipo_acomodacao
    order by total_listagens desc, bairro, tipo_acomodacao	
-------------------------------------------------------------------------------------------------------------------------------------
-- Quais são bairros possuem a maior taxa de ocupação? 
-- tendência a ter um maior tempo das propriedades alugadas (produtivas).
-- conceito de taxa de ocupação: em 365 dias, quanto tempo elas não estavam disponíveis para lugar?
-- quanto mais próximo de 100% melhor.
-- começamos o estudo por propriedade individualmente
-- taxa de ocupacao anual por propriedade
    select
        id as propriedade, 
        neighbourhood as bairro,
        name as nome_propriedade,
        availability_365 as dias_disponiveis, -- dias do ano as propriedades desse bairro ficam disponíveis
		(365 - availability_365) as dias_ocupados, -- dias do ano as propriedades desse bairro ficam ocupadas
        (availability_365/365) *100 as taxa_disponibilidade, -- taxa de disponibilidade da propriedade
        (100-((availability_365/365) *100 )) as taxa_ocupacao -- taxa de ocupação da propriedade
    from listings
    where neighbourhood is not null
      and room_type = 'Entire home/apt'
    order by taxa_ocupacao desc
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- agora, precisamos descobrir a taxa de ocupação por bairro, para descobrir quais são os bairros mais visitados e melhores candidatos a investimento
-- para isso, tiramos a média aritmética simples (avg) que as propriedades passam disponíveis para locação durante os 365 dias do ano
-- taxa de ocupacao media por bairro do ranking
    select
        neighbourhood as bairro,
        (365 - avg(availability_365)) as media_dias_ocupados_bairro, -- média de dias do ano as propriedades desse bairro ficam disponíveis
        (100-(avg (availability_365)/365)*100) as taxa_ocupacao_bairro -- taxa média de ocupação das propriedades desse bairro ao longo do ano
        from listings
    where neighbourhood in ('Allston-Brighton',
                            'Jamaica Plain',
                            'South End',
                            'Back Bay',
                            'Fenway/Kenmore',
                            'South Boston',
                            'Dorchester',
                            'Beacon Hill',
                            'North End',
                            'East Boston')
      and room_type = 'Entire home/apt'		
    group by bairro
    order by taxa_ocupacao_bairro desc
-- taxa de ocupacao media por bairro da amostra
    select
        neighbourhood as bairro,
        (365 - avg(availability_365)) as media_dias_ocupados_bairro, -- média de dias do ano as propriedades desse bairro ficam disponíveis
        (100-(avg (availability_365)/365)*100) as taxa_ocupacao_bairro, -- taxa média de ocupação das propriedades desse bairro ao longo do ano
        count(distinct id) as nro_propriedades                          -- número de propriedades
        from listings
    where neighbourhood is not null
      and room_type = 'Entire home/apt'		
    group by bairro
    order by taxa_ocupacao_bairro desc
-------------------------------------------------------------------------------------------------------------------------------------
-- Qual o número de propriedades, o preço médio por bairro e seria interessante também saber quantas propriedades tem 	
-- combo chart bairroXnumero_de_propriedadesXpreco_medioXtaxa_ocupacao_bairroXfaturamento_anual
    select
        l.neighbourhood as bairro,
        min(l.zipcode),	
        count(distinct(l.id)) as numero_de_propriedades,
        avg(c.price) as preco_medio,
		(100-(avg (availability_365)/365)*100) as taxa_ocupacao_bairro,
        (100-(avg (availability_365)/365)*100) * 365 * avg(c.price) as faturamento_anual
    from listings as l
        join calendar as c on l.id=c.listing_id
    where l.id is not null
        and l.neighbourhood is not null
        and room_type = 'Entire home/apt'				
        and c.price is not null
    group by bairro
    having count(distinct(l.id)) >= 10    
    order by faturamento_anual desc	
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
 -- Quais fatores mais impactam o preço das propriedades?
 -- Como o preço se relaciona com os outros atributos?
 -- Qual a quantidade de dormitórios mais valorizada (maior preço)?
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-- as propriedades que possuem mais receita, onde estão e quais são as regiões mais caras?
-- propriedades com maior faturamento_anual
-- acima de usd 300 mil
    select
        l.id,
        l.property_type as tipo_propriedade,        
        l.neighbourhood as bairro,        
        l.host_id,
        l.host_name,
        sum(c.price) as faturamento_anual,
        avg(c.price) as preco_medio
    from listings as l
    join calendar as c   on l.id=c.listing_id
    where l.id is not null
        and l.neighbourhood is not null
        and room_type = 'Entire home/apt'				
        and c.price is not null	
    group by         l.id,
        l.property_type,        
        l.neighbourhood,        
        l.host_id,
        l.host_name
    having sum(c.price) > 300000        
    order by faturamento_anual desc
	-------------------------------------------------------------------------------------------------------------------------------------
-- hosts com maior faturamento_anual
-- acima de usd 300 mil
    select
        l.host_id,
        l.host_name,	
        l.property_type as tipo_propriedade,
        sum(c.price) as faturamento_anual,
        avg(c.price) as preco_medio
    from listings as l
    join calendar as c   on l.id=c.listing_id
    where l.id is not null
        and l.neighbourhood is not null
        and room_type = 'Entire home/apt'				
        and c.price is not null	
    group by         l.host_id,
        l.host_name,
        l.property_type
    having sum(c.price) > 300000        
    order by faturamento_anual desc
-------------------------------------------------------------------------------------------------------------------------------------
-- hosts com maior faturamento_anual por bairro
-- acima de usd 300 mil
    select
        l.host_id,
        l.host_name,	
        l.property_type as tipo_propriedade,        
        l.neighbourhood as bairro,        
        sum(c.price) as faturamento_anual,
        avg(c.price) as preco_medio,
        count(distinct l.id) as total_imoveis
    from listings as l
    join calendar as c   on l.id=c.listing_id
    where l.id is not null
        and l.neighbourhood is not null
        and l.room_type = 'Entire home/apt'				
        and c.price is not null
        and l.host_id in (30283594, 25188, 4962900, 9410008, 22348222, 1444340, 9419684, 814298, 51673899, 22541573)	
    group by         l.host_id,
        l.host_name,
        l.property_type,        
        l.neighbourhood
    having sum(c.price) > 300000        
    order by faturamento_anual desc
-------------------------------------------------------------------------------------------------------------------------------------	
-- nº de quartos de apartamento com maior faturamento anual dos top hosts
-- acima de usd 200 mil
    select
        l.host_name,	
        l.bedrooms as n_quartos,
        sum(c.price) as faturamento_anual,
        avg(c.price) as preco_medio
    from listings as l
    join calendar as c   on l.id=c.listing_id
    where l.id is not null
        and l.neighbourhood is not null
        and l.room_type = 'Entire home/apt'				
        and l.property_type = 'Apartment'
        and c.price is not null	
        and l.bedrooms BETWEEN 1 and 4 
        and l.host_name in ('Kara',
'Seamless',
'Alicia',
'Mike',
'Stay Alfred',
'Jason',
'Will',
'Brent',
'Harriette Ferne')
    group by         l.host_id,
        l.host_name,
        l.bedrooms
    having sum(c.price) > 200000        
    order by faturamento_anual desc	
-------------------------------------------------------------------------------------------------------------------------------------	
-- avaliação dos top hosts
-- scores hosts
select t.top_host, 
       avg(t.ano) as ano_medio,
       avg(t.nro_reviews) as media_reviews,
       avg(t.rating) as rating_medio, 
       avg(t.nota_limpeza) as media_limpeza,
       avg(t.nota_comunicacao) as media_comunicacao,
       avg(t.nota_localizacao) as media_localizacao,
       avg(t.nota_valor) as media_valor
 from 
(
select host_name as nome,
       'S' as top_host,
       max(host_is_superhost) as super,
       min(host_desde_ano) as ano, 
       sum (number_of_reviews) as nro_reviews,
       avg(review_scores_rating) as rating,
       avg(review_scores_cleanliness) as nota_limpeza,
       avg(review_scores_communication) as nota_comunicacao,
       avg(review_scores_location) as nota_localizacao,
       avg(review_scores_value) as nota_valor
from listings
where host_id in (30283594, 25188, 4962900, 9410008, 22348222, 1444340, 9419684, 814298, 51673899, 22541573)	
group by host_name
union ALL
select host_name as nome,
       'N' as top_host,
       max(host_is_superhost) as super,
       min(host_desde_ano) as ano, 
       sum (number_of_reviews) as nro_reviews,
       avg(review_scores_rating) as rating,
       avg(review_scores_cleanliness) as nota_limpeza,
       avg(review_scores_communication) as nota_comunicacao,
       avg(review_scores_location) as nota_localizacao,
       avg(review_scores_value) as nota_valor
from listings
where host_id not in (30283594, 25188, 4962900, 9410008, 22348222, 1444340, 9419684, 814298, 51673899, 22541573)	
group by host_name
) as t
group by t.top_host
order by t.nome	
-------------------------------------------------------------------------------------------------------------------------------------
-- Top Hosts x Hosts Normais: Preço médio e Faturamento
select t.top_host, avg(t.preco_medio) as media_preco from 
(
    select
        'S' as top_host,
        l.host_name,	
--        sum(c.price) as faturamento_anual,
        avg(c.price) as preco_medio
    from listings as l
    join calendar as c   on l.id=c.listing_id
    where l.id is not null
        and l.neighbourhood is not null
        and l.room_type = 'Entire home/apt'				
        and l.property_type = 'Apartment'
        and c.price is not null	
        and l.bedrooms BETWEEN 1 and 4 
        and l.host_name in ('Kara',
'Seamless',
'Alicia',
'Mike',
'Stay Alfred',
'Jason',
'Will',
'Brent',
'Harriette Ferne')
    group by    
        l.host_name
union ALL    
    select
        'N' as top_host,
        l.host_name,	
--        sum(c.price) as faturamento_anual,
        avg(c.price) as preco_medio
    from listings as l
    join calendar as c   on l.id=c.listing_id
    where l.id is not null
        and l.neighbourhood is not null
        and l.room_type = 'Entire home/apt'				
        and l.property_type = 'Apartment'
        and c.price is not null	
        and l.bedrooms BETWEEN 1 and 4 
        and l.host_name not in ('Kara',
'Seamless',
'Alicia',
'Mike',
'Stay Alfred',
'Jason',
'Will',
'Brent',
'Harriette Ferne')
    group by    
        l.host_name
) t
group by t.top_host
order by t.top_host desc, t.preco_medio desc
-------------------------------------------------------------------------------------------------------------------------------------
-- Análise das sazonalidades
-- Quando  as pessoas gostam de visitar Boston?
-- Segmentacao de visitas por períodos por mês 2016
    select 
	      month(date) as mes,
          count(distinct listing_id) as total_visitas,
		  avg(price) as preco_medio
     from calendar
	 where year(date) = 2016
      group by mes
	  order by mes

-------------------------------------------------------------------------------------------------------------------------------------
-- selecionando o ano e o mês do calendario
select * from (
select listing_id, date, year, month, 
       case 
           when day_of_week=1 then "segunda"
           when day_of_week=2 then "terça"           
           when day_of_week=3 then "quarta"           
           when day_of_week=4 then "quinta"
           when day_of_week=5 then "sexta"
           when day_of_week=6 then "sábado"
           when day_of_week=7 then "domingo"    
           else "erro"
           end as weekday,
       available, price    
  from (
    select
          listing_id,
          date,
--          cast(left(date, 4) as integer) as year,
          year(date),
		  month(date),
		  date_part("dayofweek", date) as day_of_week,
          available,
          price
     from calendar
    ) as t1) as t2
--where t2.weekday = "erro"    
limit 100
-------------------------------------------------------------------------------------------------------------------------------------		
    select
    listing_id,
    year,
    month,
    case
           when day_of_week=1 then "segunda"
           when day_of_week=2 then "terça"           
           when day_of_week=3 then "quarta"           
           when day_of_week=4 then "quinta"
           when day_of_week=5 then "sexta"
           when day_of_week=6 then "sábado"
           when day_of_week=7 then "domingo"    
           else "erro"
    end as weekday,
        price
    from
            (
            select 
                listing_id,
                year(date),
                month(date),
                date_part("dayofweek", date) as day_of_week,
                price
            from 
            calendar
            ) as t1
-------------------------------------------------------------------------------------------------------------------------------------		
    #meses do ano onde o preço médio é maior
        select
            avg(price) as avg_price,
            month_of_year
    from
            (
            select
                listing_id,
                year,
                case
                    when month =1 then "january"
                    when month =2 then "february"
                    when month =3 then "march"
                    when month =4 then "april"
                    when month =5 then "may"
                    when month =6 then "june"
                    when month =7 then "july"
                    when month =8 then "august"
                    when month =9 then "september"
                    when month =10 then "october"
                    when month =11 then "november"
                    when month =12 then "december"
                    else "erro"
                    end as month_of_year,
                case
                    when day_of_week=1 then "segunda"
                    when day_of_week=2 then "terça"           
                    when day_of_week=3 then "quarta"           
                    when day_of_week=4 then "quinta"
                    when day_of_week=5 then "sexta"
                    when day_of_week=6 then "sábado"
                    when day_of_week=7 then "domingo"    
                    else "erro"
                    end as weekday,
                price
            from
                    (
                    select 
                        listing_id,
                        year(date),
                        month(date) as month,
                        date_part("dayofweek", date) as day_of_week,
                        price
                    from 
                    calendar
                    ) as subselect
            ) as subselect2
    group by month_of_year
    order by avg_price desc
-------------------------------------------------------------------------------------------------------------------------------------		
-- dias da semana onde o preço é maior
        select
            avg(price) as avg_price,
            weekday
    from
            (
            select
                listing_id,
                year,
                month,
                case
                   when day_of_week=1 then "segunda"
                   when day_of_week=2 then "terça"           
                   when day_of_week=3 then "quarta"           
                   when day_of_week=4 then "quinta"
                   when day_of_week=5 then "sexta"
                   when day_of_week=6 then "sábado"
                   when day_of_week=7 then "domingo"    
                   else "erro"
                   end as weekday,
                price
            from
                    (
                    select 
                        listing_id,
                        year(date),
                        month(date),
                        date_part("dayofweek", date) as day_of_week,
                        price
                    from 
                    calendar
                    ) as subselect
            ) as subselect2
    group by weekday
    order by avg_price desc
-------------------------------------------------------------------------------------------------------------------------------------		
-- booking ao longo do ano para saber se a demanda é maior em algum mês do ano
    select
        sum(number_of_reviews) total_review,
        case
                    when month =1 then "january"
                    when month =2 then "february"
                    when month =3 then "march"
                    when month =4 then "april"
                    when month =5 then "may"
                    when month =6 then "june"
                    when month =7 then "july"
                    when month =8 then "august"
                    when month =9 then "september"
                    when month =10 then "october"
                    when month =11 then "november"
                    when month =12 then "december"
                    else "0"
                    end as month_of_year
    from
    (
            select 
                l.id,
                l.availability_365,
                l.number_of_reviews,
                c.date,
                year(c.date),
                month(c.date)
            from listings as l
            join calendar as c on l.id=c.listing_id
            ) as subselect1
    group by month_of_year
-------------------------------------------------------------------------------------------------------------------------------------		
-- contando o número de reviews que is imoveis listados em singapore recebeu ao longo do ano de 2022
    select
        sum(number_of_reviews) as number_of_review,
        case
                    when month =1 then "january"
                    when month =2 then "february"
                    when month =3 then "march"
                    when month =4 then "april"
                    when month =5 then "may"
                    when month =6 then "june"
                    when month =7 then "july"
                    when month =8 then "august"
                    when month =9 then "september"
                    when month =10 then "october"
                    when month =11 then "november"
                    when month =12 then "december"
                    else "erro"
                    end as month_of_year
    from
                (select 
                    count(distinct(id)) as number_of_reviews,
                    month(date)
                from reviews
                where year(date) between 2021 and 2022
                group by month
                order by number_of_reviews desc
                ) as subselect1
    group by month_of_year
    order by number_of_reviews desc
-------------------------------------------------------------------------------------------------------------------------------------		
select 
        sum(
            case
                    when  available = true then 0
                    when available = false then 1
                    else 10000
            end ) as booking,
        case 
            when month =1 then "january"
            when month =2 then "february"
            when month =3 then "march"
            when month =4 then "april"
            when month =5 then "may"
            when month =6 then "june"
            when month =7 then "july"
            when month =8 then "august"
            when month =9 then "september"
            when month =10 then "october"
            when month =11 then "november"
            when month =12 then "december"
            else "erro"
        end as month_of_year
        from
        (
                    select 
            available,
            date,
            year(date),
            month(date)
        from calendar 
            ) as subselect
    group by month_of_year
    order by booking desc
-------------------------------------------------------------------------------------------------------------------------------------		