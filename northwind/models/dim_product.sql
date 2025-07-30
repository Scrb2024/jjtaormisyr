with stg_products as (
    select * from {{ source('northwind', 'Products') }}
),

stg_categories as (
    select * from {{ source('northwind', 'Categories') }}
),

dim_supplier as (
    select supplierid, supplierkey from {{ ref('dim_supplier') }}
)

select 
    {{ dbt_utils.generate_surrogate_key(['p.productid']) }} as productkey,
    p.productid,
    p.productname,
    s.supplierkey,  -- now pulling surrogate key
    c.categoryname,
    c.description as categorydescription

from stg_products p
left join dim_supplier s
    on p.supplierid = s.supplierid
left join stg_categories c
    on p.categoryid = c.categoryid