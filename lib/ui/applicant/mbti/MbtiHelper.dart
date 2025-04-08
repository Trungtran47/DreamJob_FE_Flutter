class MbtiHelper {
  static String getExplanation(String mbti) {
    switch (mbti) {
      case 'INTJ':
        return ' INTJ - Nhà khoa học INTJ chỉ chiếm khoảng 2% dân số, và họ thường rất thông minh và quyết đoán. Với khả năng tổ chức và tư duy phân tích, họ thích hợp với các công việc nghiên cứu, chiến lược và quản lý. Các nghề nghiệp phù hợp: chuyên gia nghiên cứu, nhà khoa học, nhà quản lý chiến lược.';
      case 'INTP':
        return 'INTP - Nhà tư duy INTP yêu thích lý thuyết và khám phá, chiếm khoảng 3% dân số. Họ thường tìm thấy niềm vui trong việc giải quyết vấn đề và nghiên cứu. Các nghề nghiệp phù hợp: nhà nghiên cứu, kỹ sư phần mềm, nhà phát triển công nghệ.';
      case 'ENTJ':
        return ' ENTJ - Nhà điều hành ENTJ chiếm khoảng 3% dân số và được biết đến với khả năng lãnh đạo xuất sắc. Họ thích hoạch định chiến lược và quản lý các tổ chức. Các nghề nghiệp phù hợp: giám đốc điều hành, nhà quản lý kinh doanh, chính trị gia.';
      case 'ENTP':
        return 'ENTP - Người nhìn xa ENTP rất sáng tạo và thích tranh luận, chiếm khoảng 3% dân số. Họ thường thành công trong các lĩnh vực đòi hỏi sự đổi mới và thách thức tư duy hiện có. Các nghề nghiệp phù hợp: luật sư, nhà phát triển sản phẩm, doanh nhân.';
      case 'INFJ':
        return 'INFJ - Người che chở: INFJ rất hiếm, chỉ chiếm 1% dân số. Họ có lòng trắc ẩn sâu sắc và thường tìm thấy mục đích trong việc giúp đỡ người khác. Các nghề nghiệp phù hợp: nhà tư vấn, chuyên gia tâm lý, giáo viên, nhà hoạt động xã hội.';
      case 'INFP':
        return 'INFP - Người lý tưởng hóa: Chiếm khoảng 4,5% dân số, INFP thường là những người nhạy cảm, đầy đam mê, và theo đuổi giá trị cá nhân. Họ yêu thích các công việc cho phép họ biểu đạt cảm xúc và lý tưởng. Các nghề nghiệp phù hợp: nhà văn, nhà thơ, chuyên gia trị liệu, nhà tư vấn nhân văn.';
      case 'ENFJ':
        return ' ENFJ - Người cho đi ENFJ (2% dân số) rất lôi cuốn và có khả năng truyền cảm hứng. Họ thường thành công trong các công việc yêu cầu sự giao tiếp và lãnh đạo. Các nghề nghiệp phù hợp: giáo viên, diễn giả, nhà lãnh đạo tổ chức, chuyên gia nhân sự.';
      case 'ENFP':
        return 'ENFP Người truyền cảm hứng Chiếm khoảng 7% dân số, ENFP rất tò mò và đam mê. Họ yêu thích những công việc sáng tạo và có tính xã hội. Các nghề nghiệp phù hợp: nhà sáng tạo nội dung, diễn viên, chuyên gia marketing, nhà báo.';
      case 'ISTJ':
        return 'ISTJ - (Người trách nhiệm): ISTJ là nhóm tính cách phổ biến nhất với khoảng 13% dân số thế giới. Những người ISTJ rất tôn trọng sự thật, thực tế và có khả năng ghi nhớ thông tin lâu dài. Họ thường thành công trong các công việc liên quan đến hành chính, quản lý, luật pháp và tài chính. Các nghề nghiệp phù hợp: kế toán, kiểm toán viên, nhân viên pháp lý, quản lý dự án.';
      case 'ISFJ':
        return 'ISFJ - (Người nuôi dưỡng): ISFJ là nhóm tính cách có lòng vị tha nhất, chiếm khoảng 12,5% dân số. Họ là những người chăm sóc, bảo vệ và thường tìm thấy niềm vui trong các công việc liên quan đến y tế, giáo dục, xã hội. Các nghề nghiệp phù hợp: giáo viên, y tá, nhân viên công tác xã hội, tư vấn viên.';
      case 'ESTJ':
        return ' ESTJ - Người giám hộ ESTJ (11,5% dân số) là những người có tính kỷ luật cao và thích quản lý, tổ chức. Họ phù hợp với các công việc liên quan đến quản lý và điều hành. Các nghề nghiệp phù hợp: quản lý, giám đốc, chuyên viên quản lý dự án.';
      case 'ESFJ':
        return '. ESFJ - Người quan tâm ESFJ chiếm khoảng 12% dân số, họ có bản tính thực tế và luôn sẵn sàng giúp đỡ người khác. Họ phù hợp với các công việc cộng đồng, xã hội và chăm sóc. Các nghề nghiệp phù hợp: giáo viên, nhân viên xã hội, quản trị viên văn phòng.';
      case 'ISTP':
        return 'ISTP - (Nhà kỹ thuật): ISTP (5% dân số) là những người có tư duy logic và thích sửa chữa, cải tiến. Họ yêu thích sự tự do và tính thực tế, thường thành công trong các công việc kỹ thuật. Các nghề nghiệp phù hợp: kỹ sư, thợ máy, chuyên viên IT, chuyên gia phân tích hệ thống.';
      case 'ISFP':
        return 'ISFP - (Người nghệ sĩ): Với khoảng 8% dân số, ISFP là những người tự phát và không thể đoán trước. Họ thích sự sáng tạo và tự do, thường tìm thấy niềm vui trong nghệ thuật, thiết kế, và các lĩnh vực yêu cầu sự linh hoạt. Các nghề nghiệp phù hợp: nhà thiết kế, nhiếp ảnh gia, nhạc sĩ, nghệ sĩ.';
      case 'ESTP':
        return 'ESTP - Người thực thi Với 4% dân số, ESTP là những người yêu thích hành động và luôn sống trong hiện tại. Họ thích hợp với các công việc đòi hỏi sự linh hoạt và quyết đoán. Các nghề nghiệp phù hợp: nhà doanh nghiệp, nhà đầu tư, chuyên viên tư vấn kinh doanh.';
      case 'ESFP':
        return 'ESFP - Người trình diễn Chiếm khoảng 7,5% dân số, ESFP là những người yêu thích sự vui vẻ và luôn sống hết mình với hiện tại. Họ thường thành công trong các lĩnh vực giải trí và truyền thông. Các nghề nghiệp phù hợp: diễn viên, ca sĩ, MC, nhà tổ chức sự kiện.';
      default:
        return 'Không có giải thích cho kết quả này.';
    }
  }
}
