const reportRepository = require('../repository/reportRepository');
const modulRepository = require('../repository/modulRepository');

const createReport = async ({ userId, modulId, reason, note }) => {
  if (!modulId) throw new Error("modul_id is required");
  if (!reason) throw new Error("reason is required");

  const modul = await modulRepository.getDetailModulById(modulId);
  if (!modul) throw new Error("Modul tidak ditemukan");

  const existing = await reportRepository.findByUserAndModul(userId, modulId);
  if (existing) {
    return { message: "Kamu sudah pernah melaporkan modul ini.", data: existing };
  }

  const created = await reportRepository.createReport({
    user_id: userId,
    modul_id: modulId,
    reason,
    note: note ?? null
  });

  return { message: "Laporan berhasil dikirim.", data: created };
};

const getAllReports = async () => {
  return reportRepository.getAllReports();
};

const resolveReport = async (reportId) => {
  if (!reportId) throw new Error("report id is required");
  return reportRepository.resolveReport(reportId);
};

const getReportById = async (userId) => {
  return reportRepository.getReportById(userId);
};

const getReportByUserId = async (userId) => {
  return reportRepository.getReportByUserId(userId);
};


module.exports = {
  createReport,
  getAllReports,
  resolveReport,
  getReportById,
  getReportByUserId
};
