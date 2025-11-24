-- TẠO BẢNG VÀ CHÈN DỮ LIỆU (đã cho)
CREATE DATABASE Chitietdonhang;
USE Chitietdonhang;
CREATE TABLE ChiTietDonHang (
    ma_chi_tiet INT,
    ma_don_hang INT,
    ten_san_pham VARCHAR(100),
    so_luong INT,
    don_gia DECIMAL(10, 2),
    thanh_tien DECIMAL(10, 2)
);

INSERT INTO ChiTietDonHang (ma_chi_tiet, ma_don_hang, ten_san_pham, so_luong, don_gia, thanh_tien) VALUES
(1, 1001, 'Cà Phê Sữa', 2, 29000.00, 58000.00),
(2, 1001, 'Bạc Xỉu', 1, 35000.00, 35000.00),
(3, 1002, 'Trà Đào Cam Sả', 1, 45000.00, 45000.00),
(4, 1003, 'Cà Phê Sữa', 1, 29000.00, 29000.00),
(5, 1004, 'Trà Sữa Trân Châu Đường Đen', 2, 55000.00, 110000.00),
(6, 1005, 'Bạc Xỉu', 1, 35000.00, 35000.00),
(7, 1006, 'Cà Phê Sữa', 3, 29000.00, 87000.00),
(8, 1006, 'Trà Chanh Gừng Mật Ong', 1, 42000.00, 42000.00),
(9, 1007, 'Trà Đào Cam Sả', 2, 45000.00, 90000.00),
(10, 1008, 'Trà Sữa Trân Châu Đường Đen', 1, 55000.00, 55000.00),
(11, 1009, 'Cà Phê Sữa', 1, 29000.00, 29000.00),
(12, 1010, 'Trà Chanh Gừng Mật Ong', 1, 42000.00, 42000.00);

-- NHIỆM VỤ 1: BÁO CÁO HIỆU SUẤT SẢN PHẨM
--  - tong_so_ly_ban: tổng số ly (tổng so_luong)
--  - tong_doanh_thu: tổng doanh thu (tổng thanh_tien)
--  - so_don_hang_chua_sp: số đơn hàng khác nhau có chứa sản phẩm (COUNT DISTINCT ma_don_hang)

SELECT
    ten_san_pham,
    SUM(so_luong)                        AS tong_so_ly_ban,
    SUM(thanh_tien)                      AS tong_doanh_thu,
    COUNT(DISTINCT ma_don_hang)          AS so_don_hang_chua_sp
FROM
    ChiTietDonHang
GROUP BY
    ten_san_pham
ORDER BY
    tong_doanh_thu DESC;  -- sắp xếp theo doanh thu giảm dần để dễ xác định "ngôi sao"

-- NHIỆM VỤ 2: PHÂN TÍCH VÀ ĐỀ XUẤT CHIẾN LƯỢC
/*
PHÂN LOẠI SẢN PHẨM (dựa trên kết quả chạy truy vấn ở trên)
Tóm tắt (kết quả tổng hợp từ dữ liệu mẫu):
- Cà Phê Sữa
    - tong_so_ly_ban = 7
    - tong_doanh_thu = 203,000.00
    - so_don_hang_chua_sp = 4
- Trà Sữa Trân Châu Đường Đen
    - tong_so_ly_ban = 3
    - tong_doanh_thu = 165,000.00
    - so_don_hang_chua_sp = 2
- Trà Đào Cam Sả
    - tong_so_ly_ban = 3
    - tong_doanh_thu = 135,000.00
    - so_don_hang_chua_sp = 2
- Trà Chanh Gừng Mật Ong
    - tong_so_ly_ban = 2
    - tong_doanh_thu = 84,000.00
    - so_don_hang_chua_sp = 2
- Bạc Xỉu
    - tong_so_ly_ban = 2
    - tong_doanh_thu = 70,000.00
    - so_don_hang_chua_sp = 2
Phân loại (theo tiêu chí: doanh thu tổng + mức độ phổ biến (số đơn)):
- 2 sản phẩm "Ngôi sao" (hiệu suất tốt nhất):
    1) Cà Phê Sữa
       - Lý do: Doanh thu cao nhất (203,000) cộng với số đơn hàng lớn nhất (4 đơn) và số ly bán nhiều (7 ly). Vừa mang lại doanh thu lớn, vừa phổ biến — rõ ràng là sản phẩm chủ lực.
    2) Trà Sữa Trân Châu Đường Đen
       - Lý do: Doanh thu đứng thứ 2 (165,000) dù số đơn bằng nhiều sản phẩm khác (2 đơn). Giá trên ly cao hơn (don_gia = 55,000) nên đóng góp doanh thu lớn với số lượng vừa phải — có tiềm năng đầu tư thêm để tăng tần suất mua.
- 2 sản phẩm "Cần xem xét" (hiệu suất thấp nhất):
    1) Bạc Xỉu
       - Lý do: Doanh thu thấp nhất trong danh sách (70,000) mặc dù số đơn = 2. Don_gia tương đối (35,000) nhưng tổng lượng/đơn không cao => có thể là ít người mua hoặc khách chọn món khác.
    2) Trà Chanh Gừng Mật Ong
       - Lý do: Doanh thu thấp (84,000) và số đơn chỉ 2. Mặc dù không thấp hơn quá nhiều so với Trà Đào, nhưng so với top sản phẩm thì hiệu suất kém hơn.

Ghi chú về cách đưa ra phân loại:
- Ưu tiên doanh thu tổng (tác động trực tiếp tới lợi nhuận/tiền mặt).
- Dùng số đơn hàng (COUNT DISTINCT ma_don_hang) làm chỉ báo mức độ phổ biến rộng — nếu sản phẩm có doanh thu cao nhưng trên ít đơn, đó có thể là do giá cao hoặc bán lẻ theo combo; cần cân nhắc cả hai.
- Với dữ liệu mẫu (tháng vừa qua) và quy mô nhỏ, phân loại này có ý nghĩa định hướng. Nếu có thêm dữ liệu (vài tháng, kênh bán hàng), ta nên tính thêm tỉ lệ lặp lại của khách, biên lợi nhuận gộp, v.v.

ĐỀ XUẤT CHIẾN LƯỢC (cụ thể, hành động cho 1 "ngôi sao" và 1 "cần xem xét"):

A) Với sản phẩm "Ngôi sao" — Cà Phê Sữa:
   - Mục tiêu: Tăng tần suất mua lặp lại và tăng giá trị trung bình đơn hàng.
   - Đề xuất chương trình khuyến mãi:
     + Chương trình "Mua 4 tặng 1 (Cà Phê Sữa)": Khuyến khích khách hàng mua nhiều lần để được ly miễn phí — đặc biệt hiệu quả với sinh viên, khách địa phương quen.
     + Gói combo "Cà Phê Sữa + Bánh ngọt" với giá ưu đãi (ví dụ giảm 10-15% so với mua lẻ) để nâng giá trị đơn hàng trung bình.
     + Thử nghiệm upsell tại quầy/ứng dụng: "Thêm trân châu/đá xay với +X đồng" — nếu có thể tăng giá trị thêm trên mỗi đơn.
   - Tiện ích theo dõi: Theo dõi conversion của chương trình trong 4 tuần, đo doanh thu trung bình/đơn, và tỉ lệ khách quay lại.

B) Với sản phẩm "Cần xem xét" — Bạc Xỉu:
   - Mục tiêu: Kiểm tra nguyên nhân doanh số thấp và thử phục hồi/loại bỏ nếu không hiệu quả.
   - Hành động cụ thể (tuần thử nghiệm 2-4 tuần):
     1) A/B Test công thức: Thử 1 biến thể "Bạc Xỉu (đậm hơn/mịn hơn/ít đường hơn)" trong 2 tuần tại 1 cửa hàng, thu feedback trực tiếp.
     2) Giảm giá thử (trial discount): Khuyến mãi "Bạc Xỉu - 20% cho lần thử đầu tiên" hoặc "second cup 50% off" để khuyến khích khách thử lại và tăng số đơn.
     3) Thay đổi vị trí trên menu / tên gọi: Đôi khi việc đổi tên hấp dẫn hơn (ví dụ "Bạc Xỉu Đặc Biệt") hoặc đưa vào mục "Hot picks" có thể tăng tỉ lệ chọn.
     4) Nếu sau 1 tháng thử nghiệm (A/B + ưu đãi) không thấy cải thiện đáng kể về doanh thu hoặc số đơn, cân nhắc loại khỏi menu theo từng cửa hàng (phiên bản tối giản) hoặc giữ làm sản phẩm theo mùa/chỉ bán vào giờ nhất định.
   - Tiện ích theo dõi: So sánh số đơn và doanh thu trước/sáu tùng nâng cấp, khảo sát ngắn khách hàng (nếu có app/hoặc QR feedback) để hiểu lý do không chọn sản phẩm.

LỜI KẾT NGẮN:
- Dữ liệu mẫu cho thấy "Cà Phê Sữa" là sản phẩm chủ lực (ngôi sao) cả về doanh thu lẫn phổ biến => ưu tiên giữ, tối ưu upsell & chương trình khách hàng thân thiết.
- "Trà Sữa Trân Châu Đường Đen" là ngôi sao thứ 2 theo doanh thu — cân nhắc đẩy thêm qua combo hoặc ưu đãi nhóm.
- "Bạc Xỉu" và "Trà Chanh Gừng Mật Ong" là nhóm cần xem xét — áp dụng thử nghiệm (cải tiến công thức, giảm giá thử, thay đổi vị trí giới thiệu) trước khi quyết định loại khỏi menu.
- Khuyến nghị: Lặp lại phân tích này mỗi tháng/quý, mở rộng tập dữ liệu (kênh bán online/offline, giờ, địa điểm) và thêm chỉ số lợi nhuận gộp nếu cần ra quyết định triệt để (ví dụ loại sản phẩm).

*/