const functions = require('firebase-functions');
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'asadcodecraft@gmail.com',      // your Gmail
    pass: 'qzhq adjc eaty awme',            // Gmail app password
  },
});

exports.sendEmail = functions.https.onCall(async (data, context) => {
  const { to, subject, message } = data;

  if (!to || !subject || !message) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing to, subject, or message.'
    );
  }

  try {
    await transporter.sendMail({
      from: 'asadcodecraft@gmail.com', // your email
      to: to,                         // customer email
      subject: subject,
      text: message,
    });
    return { result: 'Email sent successfully' };
  } catch (error) {
    console.error('Error sending email:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to send email',
      error.toString()
    );
  }
});


