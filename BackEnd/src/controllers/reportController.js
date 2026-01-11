const reportService = require('../services/reportService')

const createReport = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const { modul_id, reason, note } = req.body;

    const modulId = parseInt(modul_id, 10);
    if (isNaN(modulId)) {
      return res.status(400).json({ code: 400, message: "modul_id tidak valid" });
    }

    const result = await reportService.createReport({
      userId,
      modulId,
      reason,
      note
    });

    res.status(200).json({
      code: 200,
      message: result.message,
      data: result.data
    });
  } catch (error) {
    res.status(400).json({ code: 400, message: error.message });
  }
};

const getAllReports = async (req, res) => {
  try {
    const data = await reportService.getAllReports();
    res.status(200).json({ code: 200, message: "OK", data });
  } catch (error) {
    res.status(400).json({ code: 400, message: error.message });
  }
};

const getReportById = async (req, res) => {
  const userId = parseInt(req.params.userId, 10);
  try{
    const data = await reportService.getReportById(userId);
    res.status(200).json({ code: 200, message: "OK", data });

  } catch (error) {
    res.status(400).json({ code: 400, message: error.message });
  }
};

const resolveReport = async (req, res) => {
  try {
    const reportId = parseInt(req.params.reportId, 10);
    if (isNaN(reportId)) {
      return res.status(400).json({ code: 400, message: "reportId tidak valid" });
    }

    const data = await reportService.resolveReport(reportId);
    res.status(200).json({ code: 200, message: "Report resolved", data });
  } catch (error) {
    res.status(400).json({ code: 400, message: error.message });
  }
};

module.exports = {
  createReport,
  getAllReports,
  resolveReport,
  getReportById
};
