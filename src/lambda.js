exports.handler = (context, event, callback) => {
    let body = {
        message: "Latest msg",
        deployEnv: process.env.APP_ENV,
        version: process.env.AWS_LAMBDA_FUNCTION_VERSION,
    }
    callback(null, body);
}
