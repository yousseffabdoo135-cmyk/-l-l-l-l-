-- شغّل الملف ده كله مرة واحدة في Supabase -> SQL Editor -> New query -> Run
create table if not exists categories (
  id text primary key default gen_random_uuid()::text,
  name_en text not null, name_ar text not null, sort int default 0
);
create table if not exists products (
  id text primary key default gen_random_uuid()::text,
  category text not null references categories(id),
  name_en text not null, name_ar text not null,
  ing_en text default '', ing_ar text default '',
  price numeric default 0, available boolean default true,
  image text default '', created_at timestamptz default now()
);
alter table categories enable row level security;
alter table products enable row level security;
drop policy if exists "read categories" on categories;
drop policy if exists "read products" on products;
drop policy if exists "admin categories" on categories;
drop policy if exists "admin products" on products;
create policy "read categories" on categories for select using (true);
create policy "read products" on products for select using (true);
create policy "admin categories" on categories for all to authenticated using (true) with check (true);
create policy "admin products" on products for all to authenticated using (true) with check (true);

insert into storage.buckets (id, name, public) values ('products','products',true) on conflict do nothing;
drop policy if exists "read images" on storage.objects;
drop policy if exists "admin add images" on storage.objects;
drop policy if exists "admin edit images" on storage.objects;
drop policy if exists "admin delete images" on storage.objects;
create policy "read images" on storage.objects for select using (bucket_id='products');
create policy "admin add images" on storage.objects for insert to authenticated with check (bucket_id='products');
create policy "admin edit images" on storage.objects for update to authenticated using (bucket_id='products');
create policy "admin delete images" on storage.objects for delete to authenticated using (bucket_id='products');

insert into categories (id,name_en,name_ar,sort) values
('espresso','Espresso','إسبريسو',1),('coffee','Coffee','قهوة',2),('hot','Hot','ساخن',3),('ice','Ice','تلج',4),('juices','Juices','عصاير',5)
on conflict (id) do nothing;

insert into products (id,category,name_en,name_ar,ing_en,ing_ar,price,available,image,created_at) values
('p0','espresso','iced latte','لاتيه مثلج','Espresso - Milk - Ice','إسبريسو - حليب - ثلج',0,true,'http://brot.ae/cdn/shop/files/Iced_Latte_1.jpg?crop=center&height=600&v=1746423624&width=600',now()+interval '0 seconds'),
('p1','espresso','iced ammericano','أمريكانو مثلج','Espresso - water - Ice','إسبريسو - ماء - ثلج',0,true,'https://messyvegancook.com/wp-content/uploads/2024/05/Coconut-water-iced-americano.jpg',now()+interval '1 seconds'),
('p2','espresso','iced chocolate','شوكولاتة مثلجة','chocolate - Milk - Ice','شوكولاتة - حليب - ثلج',0,true,'https://www.cacaobrew.co.uk/cdn/shop/articles/Iced_Chocolate2_bc38211b-194b-4ae7-9c8f-75e5cbb96100.jpg?v=1754420953',now()+interval '2 seconds'),
('p3','espresso','iced coffee','قهوة مثلجة','coffee - Milk - Ice','قهوة - حليب - ثلج',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7BVJRxUtMPbO-dazpyiFHchcFC0C6okph7NzOAiqI8x5qw2K7ZBd1zvA&s=10',now()+interval '3 seconds'),
('p4','espresso','iced mocca','موكا مثلجة','Espresso - Milk - Ice- chocolate','إسبريسو - حليب - ثلج - شوكولاتة',0,true,'https://i.pinimg.com/736x/cb/b1/6c/cbb16ce1bd7df3c5a5c3e3e8e41fb2f3.jpg',now()+interval '4 seconds'),
('p5','espresso','chocolate milkshake','ميلك شيك شوكولاتة','milk -ice cream - Milk','حليب - آيس كريم - حليب',0,true,'https://i.pinimg.com/736x/20/29/ef/2029ef7a62e7b477632b27c2db403bb8.jpg',now()+interval '5 seconds'),
('p6','espresso','iced coffee mocha','موكا قهوة مثلجة','coffee - Milk - Ice - chocolate','قهوة - حليب - ثلج - شوكولاتة',0,true,'https://www.forkinthekitchen.com/wp-content/uploads/2022/08/220629.iced_.latte_.mocha-9356.jpg',now()+interval '6 seconds'),
('p7','espresso','iced tea','شاي مثلج','tea flavor - water - Ice','نكهة شاي - ماء - ثلج',0,true,'https://upload.wikimedia.org/wikipedia/commons/e/ef/Iced_Tea_from_flickr.jpg?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=original',now()+interval '7 seconds'),
('p8','espresso','iced caramel latte','لاتيه كراميل مثلج','Espresso - Milk - Ice -caramell','إسبريسو - حليب - ثلج - كراميل',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmLOJB1Nr5Y95YTI00XJizGC4v-fiCHKezQjCJADo3cZmNkIj8E0NXbPA&s=10',now()+interval '8 seconds'),
('p9','espresso','single shot esspresso & double','إسبريسو شوت واحد واثنان','Espresso','إسبريسو',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5_yccT7AjVQ6cyz2GRya78pb89XZr5EFKZHncMtpm3vNvXNK-QJtxtpY&s=10',now()+interval '9 seconds'),
('p10','coffee','coffe single','قهوة سنجل','coffee','قهوة',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCyiJWo7HuEmcGkZxs3wOEm6TxJ9vHeiYm_TAYaZzEug&s=10',now()+interval '10 seconds'),
('p11','coffee','Cinnamon coffee','قهوة بالقرفة','coffee - Cinnamon','قهوة - قرفة',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6Li0zjHT_lDXmijR09qKf87zzWwhRz1Ykd15OP1tyPg&s=10',now()+interval '11 seconds'),
('p12','coffee','coffe double','قهوة دبل','coffee','قهوة',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_7Oqt0EzxBUA3F9pYuXa5I3RkTvStDaqOkFjo6YtD-w&s',now()+interval '12 seconds'),
('p13','coffee','french coffee','قهوة فرنسية','coffee - milk','قهوة - حليب',0,true,'https://www.thespruceeats.com/thmb/YEI_JAfLHd6fbfCYUukcW5E2TYg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/SES-cafe-au-lait-recipe-1374920-hero-01-b1463e806a7947e7b8b17979ab70eab3.jpg',now()+interval '13 seconds'),
('p14','coffee','hazelnut coffee','قهوة بالبندق','coffee - hazelnut flavor','قهوة - نكهة البندق',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRF24hV4bWtC6EbgkEqJaHUZJcYQLYH0llHQPTkxPzINw&s=10',now()+interval '14 seconds'),
('p15','coffee','Single Berlin Coffee','قهوة برلين سنجل','Berlin Coffee','قهوة برلين',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBVwSw-UAtPO6Xle5_ImK4BTQJUvhv-OA02o9C4tD6hw&s=10',now()+interval '15 seconds'),
('p16','coffee','Double Berlin Coffee','قهوة برلين دبل','Berlin Coffee','قهوة برلين',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBVwSw-UAtPO6Xle5_ImK4BTQJUvhv-OA02o9C4tD6hw&s=10',now()+interval '16 seconds'),
('p17','coffee','Berlin With Cinnamon','برلين بالقرفة','Berlin Coffee - Cinnamon','قهوة برلين - قرفة',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDjvYh5ijMi_gRGSHJRFFsy7u8ij61uVzsCnM1IAmaRw&s=10',now()+interval '17 seconds'),
('p18','hot','orucano','أوركانو','Espresso fomed','إسبريسو برغوة',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZo2ofj2yDzTCqg2_WFjURGwAj6PA_3vQbLhVL5QCGnewLVfQ75jk-yfoR&s=10',now()+interval '18 seconds'),
('p19','hot','latte','لاتيه','Espresso - Milk','إسبريسو - حليب',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3JwqHbxseEW-UsBoqoTt4mOCv9TK8DixlfoD6dVg-TMTFMIHE62kO5NqA&s=10',now()+interval '19 seconds'),
('p20','hot','cappuccino','كابتشينو','double shot Espresso - Milk','دبل إسبريسو - حليب',0,true,'https://images.ctfassets.net/0e6jqcgsrcye/6Dnzkf1ylG7IxDRG9Ez1Ia/0db4f0be1ff6199ae89afa4a0ae26687/How_to_make_a_perfect_cappuccino_at_home.jpg',now()+interval '20 seconds'),
('p21','hot','ammericano','أمريكانو','Espresso - water','إسبريسو - ماء',0,true,'https://loveincrediblerecipes.com/wp-content/uploads/2023/12/nespresso-americano.jpg',now()+interval '21 seconds'),
('p22','hot','mocha','موكا','Espresso - Milk - chocolate','إسبريسو - حليب - شوكولاتة',0,true,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpy5HKgNLUqPtnSRh5LxQEtGHdDFvnfR_nQeO5laemDlqsb7z4Z3KdiOFY&s=10',now()+interval '22 seconds'),
('p23','hot','flat white','فلات وايت','double shot Espresso - Milk','دبل إسبريسو - حليب',0,true,'https://methodicalcoffee.com/cdn/shop/articles/Flat_white_sitting_on_a_table_af78d6b5-75ea-4f88-bec7-6505412042f8.jpg?v=1761756646&width=1200',now()+interval '23 seconds'),
('p24','hot','cortado','كورتادو','double shot Espresso - single shot Milk','دبل إسبريسو - شوت حليب واحد',0,true,'https://www.acouplecooks.com/wp-content/uploads/2021/08/Cortado-004s.jpg',now()+interval '24 seconds'),
('p25','hot','latte caramel','لاتيه كراميل','Espresso - Milk - caramell flavor','إسبريسو - حليب - نكهة كراميل',0,true,'https://www.livveganstrong.com/wp-content/uploads/2024/01/caramel-latte-11.jpg',now()+interval '25 seconds'),
('p26','hot','Hazelnut Latte','لاتيه بالبندق','Espresso - Milk - Ingredients','إسبريسو - حليب - مكونات',0,true,'https://www.nescafe.com/sites/default/files/2025-10/NESCAFE%CC%81-SBU-SCTs-Recipes-2025-Gold-Hazelnut%20Creamy%20Coffee-RDP-Recipe-Image.jpg',now()+interval '26 seconds')
on conflict (id) do nothing;
