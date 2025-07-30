with stg_suppliers as (
    select * from {{ source('northwind', 'Suppliers') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['s.supplierid']) }} as supplierkey,
    s.supplierid,
    s.companyname,
    s.contactname,
    s.contacttitle,
    s.address as supplieraddress,
    s.city as suppliercity,
    s.region as supplierregion,
    s.postalcode as supplierpostalcode,
    s.country as suppliercountry,
    s.phone as supplierphone,
    s.fax as supplierfax,
    s.homepage as supplierhomepage

from stg_suppliers s