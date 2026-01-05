import 'vark_question_model.dart';

class LearningStyleDescriptions {
  static String getDescription(VarkType type) {
    switch (type) {
      case VarkType.visual:
        return 'Anda lebih mudah memahami informasi yang disajikan secara visual. '
            'Grafik, diagram, video, dan warna membantu Anda memahami konsep dengan lebih baik.';
      case VarkType.auditory:
        return 'Anda lebih mudah memahami informasi melalui pendengaran. '
            'Diskusi, ceramah, dan penjelasan verbal sangat efektif untuk Anda.';
      case VarkType.readWrite:
        return 'Anda lebih menyukai informasi dalam bentuk teks tertulis. '
            'Membaca, menulis, dan membuat catatan adalah cara terbaik Anda untuk belajar.';
      case VarkType.kinesthetic:
        return 'Anda belajar terbaik melalui pengalaman langsung dan praktik. '
            'Hands-on activities dan eksperimen sangat efektif untuk Anda.';
    }
  }

  static List<String> getStudyTips(VarkType type) {
    switch (type) {
      case VarkType.visual:
        return [
          'Gunakan grafik, diagram, dan peta pikiran',
          'Tonton video pembelajaran',
          'Gunakan warna untuk mencatat',
          'Buat flashcards dengan gambar',
          'Gunakan Presentasi visual saat belajar',
        ];
      case VarkType.auditory:
        return [
          'Rekam dan dengarkan catatan Anda',
          'Bergabung dalam kelompok diskusi',
          'Jelaskan materi dengan suara keras',
          'Dengarkan podcast edukasi',
          'Gunakan mnemonik verbal',
        ];
      case VarkType.readWrite:
        return [
          'Buat catatan yang terstruktur',
          'Tulis ulang ringkasan materi',
          'Baca教材 berulang kali',
          'Buat daftar dan checklist',
          'Tulis esai tentang materi yang dipelajari',
        ];
      case VarkType.kinesthetic:
        return [
          'Lakukan eksperimen langsung',
          'Gunakan simulasi dan role-play',
          'Berjalan saat mempelajari materi',
          'Bawa objek untuk manipulatif',
          'Istirahat aktif di antara sesi belajar',
        ];
    }
  }

  static List<String> getCareerSuggestions(VarkType type) {
    switch (type) {
      case VarkType.visual:
        return [
          'Desainer Grafis',
          'Arsitek',
          'Fotografer',
          'Ahli Visualisasi Data',
          'Kartunis/Ilustrator',
        ];
      case VarkType.auditory:
        return ['Pengacara', 'Guru/Dosen', 'Jurnalis', 'Konselor', 'Podcaster'];
      case VarkType.readWrite:
        return ['Penulis', 'Editor', 'Pustakawan', 'Akuntan', 'Peneliti'];
      case VarkType.kinesthetic:
        return [
          'Dokter/Bidan',
          'Teknisi',
          'Atlet/Pelatih',
          'Terapis Fisik',
          'Mekanik',
        ];
    }
  }

  static String getMotivation(VarkType type) {
    switch (type) {
      case VarkType.visual:
        return 'Visibilitas adalah kekuatan Anda! Gunakan kemampuan visual Anda untuk menciptakan pemahaman yang mendalam.';
      case VarkType.auditory:
        return 'Pendengaran Anda adalah super power! Suara memiliki kekuatan untuk menjelaskan konsep yang kompleks.';
      case VarkType.readWrite:
        return 'Kata-kata adalah alat Anda! Setiap tulisan yang Anda buat memperdalam pemahaman Anda.';
      case VarkType.kinesthetic:
        return 'Tindakan adalah segalanya! Pengalaman langsung Anda membawa pemahaman yang tak tertandingi.';
    }
  }
}

extension VarkColor on VarkType {
  int get colorValue {
    switch (this) {
      case VarkType.visual:
        return 0xFF4285F4; // Blue
      case VarkType.auditory:
        return 0xFFEA4335; // Red
      case VarkType.readWrite:
        return 0xFFFBBC05; // Yellow
      case VarkType.kinesthetic:
        return 0xFF34A853; // Green
    }
  }
}
