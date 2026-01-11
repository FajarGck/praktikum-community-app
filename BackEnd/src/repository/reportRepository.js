const prisma = require('../config/db');


const findByUserAndModul = async (userId, modulId) => {
    return prisma.report.findUnique({
        where: {
            user_id_modul_id : {
                user_id: userId,
                modul_id: modulId
            }
        }
    })
}

const createReport = async ({user_id, modul_id, reason, note}) => {
    return prisma.report.create({
        data: {
            user_id,
            modul_id,
            reason,
            note
        }
    })
}

const getAllReports = async () => {
  return prisma.report.findMany({
    orderBy: {created_at: 'desc'},
    include: {
      modul: {
        select: {
          modul_id: true,
          judul: true,
          thumbnail_url: true,
          status: true,
          penulis: { select: { user_id: true, username: true } },
          kategori: { select: { kategori_id: true, nama_kategori: true } }
        }
      },
      users: { select: { user_id: true, username: true, email: true } }
    }
  });
};

const resolveReport = async (reportId) => {
  return prisma.report.update({
    where: { report_id: reportId },
    data: { status: 'resolved' }
  });
};


const getReportById = async (userId) => {
  return prisma.report.findMany({
    where: { user_id: userId},
    include: {
      modul: {
        select: {
          modul_id: true,
          judul: true,
          thumbnail_url: true,
          status: true,
          penulis: { select: { user_id: true, username: true } },
          kategori: { select: { kategori_id: true, nama_kategori: true } }
        }
      },
      users: { select: { user_id: true, username: true, email: true } }
    }
  })
}

module.exports = {
  findByUserAndModul,
  createReport,
  getAllReports,
  resolveReport,
  getReportById
};