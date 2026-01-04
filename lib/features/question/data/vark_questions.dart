import '../domain/models/vark_question_model.dart';

class VarkQuestions {
  static final List<VarkQuestion> questions = [
    /// 1
    const VarkQuestion(
      id: 1,
      category: 'VARK',
      question:
          'Saya ingin mendatangi satu toko yang disarankan teman. Saya akan:',
      options: {
        VarkType.kinesthetic:
            'Mencari toko itu berdasarkan tempat lain di sekitar situ yang sudah saya tahu.',
        VarkType.auditory: 'Bertanya pada teman yang tahu arah toko itu.',
        VarkType.readWrite: 'Menuliskan alamat lengkap dan daftar belokan.',
        VarkType.visual: 'Menggunakan peta yang menunjukkan lokasi toko.',
      },
    ),

    /// 2
    const VarkQuestion(
      id: 2,
      category: 'VARK',
      question:
          'Sebuah situs memiliki video cara membuat grafik. Saya paling mengerti dengan:',
      options: {
        VarkType.visual: 'Mengamati diagram petunjuknya.',
        VarkType.auditory: 'Mendengar suara yang menjelaskan.',
        VarkType.readWrite: 'Membaca instruksi tertulis.',
        VarkType.kinesthetic: 'Melihat tindakan orangnya.',
      },
    ),

    /// 3
    const VarkQuestion(
      id: 3,
      category: 'VARK',
      question:
          'Saya ingin mengetahui lebih dalam tentang tur wisata. Saya akan:',
      options: {
        VarkType.kinesthetic: 'Melihat detail kegiatan dan aktivitas.',
        VarkType.visual: 'Melihat peta dan lokasi turnya.',
        VarkType.readWrite: 'Membaca perincian jadwal kegiatan.',
        VarkType.auditory: 'Bicara dengan pengelola atau peserta.',
      },
    ),

    /// 4
    const VarkQuestion(
      id: 4,
      category: 'VARK',
      question:
          'Dalam memilih karir atau jurusan pendidikan, yang penting bagi saya adalah:',
      options: {
        VarkType.kinesthetic: 'Aplikasi ilmu pada kondisi nyata.',
        VarkType.auditory: 'Berkomunikasi dan berdiskusi.',
        VarkType.visual: 'Pekerjaan dengan desain, peta, atau bagan.',
        VarkType.readWrite: 'Penggunaan kata yang tepat secara tertulis.',
      },
    ),

    /// 5
    const VarkQuestion(
      id: 5,
      category: 'VARK',
      question: 'Saat belajar, saya:',
      options: {
        VarkType.auditory: 'Belajar dengan berdiskusi.',
        VarkType.visual: 'Mencari pola tertentu.',
        VarkType.kinesthetic: 'Menggunakan contoh dan penerapan.',
        VarkType.readWrite: 'Membaca buku dan artikel.',
      },
    ),

    /// 6
    const VarkQuestion(
      id: 6,
      category: 'VARK',
      question: 'Saya ingin menabung lebih banyak. Saya akan:',
      options: {
        VarkType.kinesthetic:
            'Mempertimbangkan contoh berdasarkan kondisi keuangan.',
        VarkType.readWrite: 'Membaca brosur tertulis.',
        VarkType.visual: 'Menggunakan grafik pilihan tabungan.',
        VarkType.auditory: 'Bicara dengan ahli keuangan.',
      },
    ),

    /// 7
    const VarkQuestion(
      id: 7,
      category: 'VARK',
      question: 'Saya ingin mempelajari permainan kartu baru. Saya akan:',
      options: {
        VarkType.kinesthetic: 'Melihat orang lain bermain terlebih dahulu.',
        VarkType.auditory: 'Mendengar penjelasan dan bertanya.',
        VarkType.visual: 'Menggunakan diagram strategi.',
        VarkType.readWrite: 'Membaca petunjuk tertulis.',
      },
    ),

    /// 8
    const VarkQuestion(
      id: 8,
      category: 'VARK',
      question: 'Saya memiliki masalah jantung. Saya lebih suka dokter yang:',
      options: {
        VarkType.readWrite: 'Memberikan bacaan tentang masalah saya.',
        VarkType.kinesthetic: 'Menggunakan alat peraga jantung.',
        VarkType.auditory: 'Menguraikan masalah secara lisan.',
        VarkType.visual: 'Menunjukkan diagram jantung.',
      },
    ),

    /// 9
    const VarkQuestion(
      id: 9,
      category: 'VARK',
      question: 'Saya ingin mempelajari program komputer baru. Saya akan:',
      options: {
        VarkType.readWrite: 'Membaca instruksi tertulis.',
        VarkType.auditory: 'Bicara dengan orang yang paham.',
        VarkType.kinesthetic: 'Langsung mencoba dan belajar dari kesalahan.',
        VarkType.visual: 'Mengikuti diagram di buku petunjuk.',
      },
    ),

    /// 10
    const VarkQuestion(
      id: 10,
      category: 'VARK',
      question: 'Ketika belajar dari internet, saya menyukai:',
      options: {
        VarkType.kinesthetic: 'Video cara melakukan sesuatu.',
        VarkType.visual: 'Desain dan fitur visual yang menarik.',
        VarkType.readWrite: 'Uraian tertulis dan daftar.',
        VarkType.auditory: 'Situs dengan suara atau wawancara.',
      },
    ),

    /// 11
    const VarkQuestion(
      id: 11,
      category: 'VARK',
      question: 'Saya ingin mempelajari proyek kerja baru. Saya akan meminta:',
      options: {
        VarkType.visual: 'Diagram tahapan proyek.',
        VarkType.readWrite: 'Laporan tertulis proyek.',
        VarkType.auditory: 'Kesempatan berdiskusi.',
        VarkType.kinesthetic: 'Contoh proyek yang berhasil.',
      },
    ),

    /// 12
    const VarkQuestion(
      id: 12,
      category: 'VARK',
      question: 'Saya ingin belajar cara memotret lebih baik. Saya akan:',
      options: {
        VarkType.auditory: 'Bertanya dan berdiskusi.',
        VarkType.readWrite: 'Membaca instruksi kamera.',
        VarkType.visual: 'Melihat diagram komponen kamera.',
        VarkType.kinesthetic: 'Melihat contoh hasil foto.',
      },
    ),

    /// 13
    const VarkQuestion(
      id: 13,
      category: 'VARK',
      question: 'Saya lebih suka pembicara yang menggunakan:',
      options: {
        VarkType.kinesthetic: 'Peragaan atau praktik langsung.',
        VarkType.auditory: 'Diskusi dan tanya jawab.',
        VarkType.readWrite: 'Buku atau bahan bacaan.',
        VarkType.visual: 'Diagram, bagan, atau grafik.',
      },
    ),

    /// 14
    const VarkQuestion(
      id: 14,
      category: 'VARK',
      question: 'Saya ingin umpan balik setelah ujian. Saya mengharapkan:',
      options: {
        VarkType.kinesthetic: 'Contoh dari hasil kerja saya.',
        VarkType.readWrite: 'Penjelasan tertulis.',
        VarkType.auditory: 'Umpan balik langsung.',
        VarkType.visual: 'Grafik hasil pekerjaan.',
      },
    ),

    /// 15
    const VarkQuestion(
      id: 15,
      category: 'VARK',
      question:
          'Saya tertarik pada rumah/apartemen. Sebelum berkunjung saya ingin:',
      options: {
        VarkType.kinesthetic: 'Melihat video rumah.',
        VarkType.auditory: 'Berdiskusi dengan pemilik.',
        VarkType.readWrite: 'Membaca keterangan tertulis.',
        VarkType.visual: 'Melihat denah dan peta.',
      },
    ),

    /// 16
    const VarkQuestion(
      id: 16,
      category: 'VARK',
      question: 'Saya ingin merakit meja kayu. Saya paling mengerti jika:',
      options: {
        VarkType.visual: 'Mengikuti diagram instruksi.',
        VarkType.auditory: 'Mendengar saran orang lain.',
        VarkType.readWrite: 'Membaca penjelasan tertulis.',
        VarkType.kinesthetic: 'Menonton video perakitan.',
      },
    ),
  ];

  static int get totalQuestions => questions.length;
}
