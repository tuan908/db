--  QLBH:
--  I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language): --

--  2. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM
alter table
  SANPHAM
add
  GHICHU varchar(20);

--  3. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
alter table
  KHACHHANG
add
  LOAIKH tinyint;

--  4. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
alter table
  SANPHAM alter column GHICHU varchar(100);

--  5. Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
alter table
  SANPHAM
drop
  column GHICHU;

--  6. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, …
alter table
  KHACHHANG alter column LOAIKH varchar(255);

--  7. Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
alter table
  SANPHAM
add
  constraint check_product_unit check (
    dvt in (
      'cay', 'hop', 'cai', 'quyen', 'chuc'
    )
  );

--  8. Giá bán của sản phẩm từ 500 đồng trở lên.
alter table
  SanPham
add
  constraint check_product_price check (gia > 500);

--  9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
alter table
  CTHD
add
  constraint check_product_amount check (sl >= 1);

--  10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.
alter table
  KhachHang
add
  constraint check_register_membership_date check (NgDK > NgSinh);

--  II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):

--  2.1 Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM.
select
  * into SANPHAM1
from
  SanPham;
--  2.2  Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG
select
  * into KHACHHANG1
from
  KhachHang;
--  3. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
update
  SANPHAM1
set
  gia = gia * 0.05 + gia
where
  NuocSX = 'Thai Lan'
--  4. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
update
  SANPHAM1
set
  gia = gia - (gia * 0.05)
where
  NuocSX = 'Trung Quoc'
  and gia < 10000;

  /*
    5. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước
      ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ
      1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
  */
update
  KhachHang1
set
  LOAIKH = 'Vip'
where
  (
    NgDK < convert(smalldatetime, '1/1/2007', 103)
    and DoanhSo > 10000000
  )
  or (
    NgDK >= convert(smalldatetime, '1/1/2007', 103)
    and DoanhSo > 2000000
  );
--  III. Ngôn ngữ truy vấn dữ liệu:

--  1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
select
  MaSP,
  TenSP
from
  SanPham
where
  NuocSX = 'Trung Quoc';

--  2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
select
  MaSP,
  TenSP
from
  SanPham
where
  DVT in ('cay', 'quyen');

--  3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
select
  MaSP,
  TenSP
from
  SanPham
where
  MaSP like 'B%'
  and MaSP like '%01';

--  4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
select
  MaSP,
  TenSP
from
  SanPham
where
  NuocSX = 'Trung Quoc'
  and (
    (Gia >= 30000)
    and (Gia < 40000)
  );

--  5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
select
  MaSP,
  TenSP
from
  SanPham
where
  (
    NuocSX = 'Trung Quoc'
    or NuocSX = 'Thai Lan'
  )
  and (
    (Gia >= 30000)
    and (Gia < 40000)
  );
--  6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
select
  hd.SOHD,
  hd.TRIGIA
from
  QLBH_2020.dbo.HOADON AS hd
where
 hd.NGHD BETWEEN '2007-01-01' AND '2007-01-02'

--  7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
select
  hd.SoHD,
  hd.TriGia
from
  HoaDon as hd
where
	MONTH(hd.NGHD) = 1 AND YEAR(HD.NGHD) = 2007
order by
  hd.NGHD asc,
  hd.TRIGIA desc;

--  8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007
select
  hd.MaKH,
  kh.HoTen
from
  HoaDon hd
  join KhachHang kh on kh.MaKH = hd.MaKH
WHERE
  hd.NGHD = '2007-01-01'

--  9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
select
  hd.SOHD,
  hd.TRIGIA
from
  QLBH_2020.dbo.HOADON hd
  join QLBH_2020.dbo.NHANVIEN nv on nv.MaNV = hd.MaNV
where
  nv.HOTEN = 'Nguyen Van B'
  AND hd.NGHD = '2006-10-28'

--  10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
select
  c.MaSP,
  sp.TenSp
from
  HoaDon hd
  join CTHD c on c.SoHD = hd.SoHD
  join SanPham sp on sp.MaSP = c.MaSP
  join KhachHang kh on kh.MaKH = hd.MaKH
where
  kh.HoTen = 'Nguyen Van A'
  and (
    MONTH(hd.NGHD) = 10
    and YEAR(hd.NGHD) = 2006
  );

--  11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”
select
  hd.SoHD
from
  HoaDon hd
  join CTHD c on c.SoHD = hd.SoHD
  join SanPham sp on sp.MASP = c.MASP
where
  sp.MaSP in ('BB01', 'BB02');

--  12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
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

--  13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
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

--  14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
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
          hd.NgHD = '2007-01-01'
      )
  ) r

--  15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
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
      )
  ) r

--  16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
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
          YEAR(hd1.NGHD) = 2006
      )
  ) r

-- 17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
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
          and  YEAR(hd1.NGHD) = 2006
      )
  ) r
