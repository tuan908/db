-- QLBH:

-- Phan I: --

-- Cau 2.
alter table SanPham add GhiChu varchar(20);

-- Cau 3
alter table KhachHang add LoaiKH tinyint;

-- Cau 4
alter table SanPham alter column GhiChu varchar(100);

-- Cau 5
alter table SanPham drop column GhiChu;

-- Cau 6
alter table KhachHang alter column LoaiKH text;

-- Cau 7:
alter table SanPham add constraint check_product_unit check (dvt in ('cay','hop','cai','quyen','chuc'));

-- Cau 8
alter table SanPham add constraint check_product_price check (gia > 500);

-- Cau 9
alter table CTHD add constraint check_product_amount check (sl >= 1);

-- Cau 10
alter table KhachHang add constraint check_register_membership_date check (NgayDK > NgSinh);

-- Phan 2

-- Cau 2.1
select * into SanPham1 from SanPham;

-- Cau 2.2
select * into KhachHang1 from KhachHang;

-- Cau 3
update table SanPham1 set gia = gia * 0.05 + gia
where NuocSX = 'Thai Lan'

-- Cau 4
update table SanPham1 set gia = gia - (gia * 0.05)
where NuocSX = 'Trung Quoc' and gia < 10000

-- Cau 5.1
update table KhachHang1 set LoaiKH = 'Vip' where
(NgayDK < '1/1/2007' and DoanhSo > 10000000) or (NgayDK >= '1/1/2007' and DoanhSo > 2000000 );

-- Phan 3

-- Cau 1
select MaSP, TenSP from SanPham where NuocSX = 'Trung Quoc';

-- Cau 2
select MaSP, TenSP from SanPham where DVT in ('cay', 'quyen');

-- Cau 3
select MaSP, TenSP from SanPham where MaSP like 'B%' and MaSP like '%01';

-- Cau 4
select MaSP, TenSP from SanPham where NuocSX = 'Trung Quoc' and ((Gia >= 30000) and (Gia < 40000));

-- Cau 5
select MaSP, TenSP from SanPham where (NuocSX = 'Trung Quoc' or NuocSX = 'Thai Lan') and ((Gia >= 30000) and (Gia < 40000));

-- Cau 6
select SoHD, TriGia from HoaDon where NgHD >= '1/1/2007' and NgHD <= '2/1/2007';

-- Cau 7
select SoHD, TriGia from HoaDon where (NgHD >= '1/1/2007' and NgHD <= '31/1/2007')
order by NgHD asc, TriGia desc;

-- Cau 8
select hd.MaKH, kh.HoTen from HoaDon hd join KhachHang kh on kh.MaKH = hd.MaKH;

-- Cau 9
select hd.SoHD, nv.HoTen from HoaDon hd join NhanVien nv on nv.MaNV = hd.MaNV where nv.HoTen = 'Nguyen Van A';

-- Cau 10
select c.MaSP, sp.TenSp from HoaDon hd join CTHD c on c.SoHD = hd.SoHD join SanPham sp on sp.MaSP = c.MaSP
join KhachHang kh on kh.MaKH = hd.MaKH
where kh.HoTen = 'Nguyen Van A' and (hd.NgHD >= '1/10/2006' and hd.NgHD <= '31/10/2006');

-- Cau 11
select hd.SoHD from HoaDon hd join CTHD c on c.SoHD = hd.SoHD join SanPham sp on sp.SoHD = c.SoHD
where sp.MaSP in ('BB01', 'BB02');

-- Cau 12
SELECT
  r.*
from
  (
    (
      select
        hd.SoHD
      from
        HoaDon hd
        join CTHD c on c.SoHD = hd.SoHD
        join SanPham sp on sp.MASP = c.MASP
      where
        sp.MaSP = 'BB01'
        and (
          c.SL between 10
          and 20
        )
    )
    UNION
      (
        select
          hd.SoHD
        from
          HoaDon hd
          join CTHD c on c.SoHD = hd.SoHD
          join SanPham sp on sp.MASP = c.MASP
        where
          sp.MaSP = 'BB02'
          and (
            c.SL between 10
            and 20
          )
      )
  ) r


-- Cau 13
  SELECT
    r.*
  from
    (
      (
        select
          hd.SoHD
        from
          HoaDon hd
          join CTHD c on c.SoHD = hd.SoHD
          join SanPham sp on sp.MASP = c.MASP
        where
          sp.MaSP = 'BB01'
          and (
            c.SL between 10
            and 20
          )
      )
      intersect
        (
          select
            hd.SoHD
          from
            HoaDon hd
            join CTHD c on c.SoHD = hd.SoHD
            join SanPham sp on sp.MASP = c.MASP
          where
            sp.MaSP = 'BB02'
            and (
              c.SL between 10
              and 20
            )
        )
    ) r

-- Cau 14
select
  r.*
from
  (
    (
      select
        sp.MaSP,
        sp.TenSP
      from
        SanPham sp
      where
        sp.NuocSX = 'Trung Quoc'
    )
    union
      (
        select
          sp.MaSP,
          sp.TenSP
        from
          HoaDon hd
          join CTHD c on c.SoHD = hd.SoHD
          join SanPham sp on c.MaSP = sp.MASP
        where
          hd.NgHD = '1/1/2007'
      )
  ) r

-- Cau 15
select
  r.*
from
  ((
    select
      sp.MaSP,
      sp.TenSP
    from
      SanPham sp
  )
except
  (
    select
      sp1.MaSP,
      sp1.TenSP
    from
      SanPham sp1
      join CTHD c1 on c1.MaSP = sp1.MaSP
  )) r


--  Cau 16
select
  r.*
from
  (
    (
      select
        sp.MaSP,
        sp.TenSP
      from
        SanPham sp
    )
    except
      (
        select
          sp1.MaSP,
          sp1.TenSP
        from
          SanPham sp1
          join CTHD c1 on c1.MaSP = sp1.MaSP
          join HoaDon hd1 on hd1.SoHD = c1.SoHD
        where
          hd1.NgHD between '1/1/2006'
          and '31/12/2006'
      )
  ) r

-- Cau 17
select
  r.*
from
  (
    (
      select
        sp.MaSP,
        sp.TenSP
      from
        SanPham sp
      where
        sp.NuocSX = 'Trung Quoc'
    )
    except
      (
        select
          sp1.MaSP,
          sp1.TenSP
        from
          SanPham sp1
          join CTHD c1 on c1.MaSP = sp1.MaSP
          join HoaDon hd1 on hd1.SoHD = c1.SoHD
        where
          sp1.NuocSX = 'Trung Quoc'
          and (
            hd1.NgHD between '1/1/2006'
            and '31/12/2006'
          )
      )
  ) r

-- Cau 18
select
  r.*
from
  (
    select
      hd.SoHD
    from
      HOADON hd
      join CTHD c on c.SOHD = hd.SoHD
      join SANPHAM sp on sp.MaSp = c.MaSp
    where
      sp.MaSp in (
        select
          sp1.Masp
        from
          SANPHAM sp1
        where
          sp1.NuocSX = 'Singapore'
      )
  ) r

-- cau 19:
SELECT
  DISTINCT hd.SOHD
FROM
  HoaDon hd
  INNER JOIN CTHD ct ON hd.SOHD = ct.SOHD
  INNER JOIN SanPham sp ON ct.MaSP = sp.MaSP
WHERE
  hd.NGHD BETWEEN '01/01/2006'
  AND '31/12/2006'
  AND sp.NUOCSX = 'Singapore'
GROUP BY
  hd.SOHD
HAVING
  COUNT(ct.MaSP) = (
    SELECT
      count(sp1.MASP)
    FROM
      SanPham sp1
    WHERE
      sp1.NuocSX = 'Singapore'
  );




