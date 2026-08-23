exports.handler = async (event) => {
  const method = event.requestContext?.http?.method ?? "UNKNOWN";
  const path = event.rawPath ?? "/";

  return {
    statusCode: 200,
    headers: {
      "content-type": "application/json",
      "access-control-allow-origin": "*",
    },
    body: JSON.stringify({
      message: "RealWorld API placeholder. Replace this package with CodeDeploy.",
      method,
      path,
    }),
  };
};
