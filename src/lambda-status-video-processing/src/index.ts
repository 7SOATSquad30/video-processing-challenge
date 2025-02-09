import { UserData } from "./model";
import jwt from 'jsonwebtoken';
import { getUserVideos } from "./videos.repository";

export const handler = async (event: any) => {
  console.log('event', event);

  const token = event.headers.Authorization.split(" ")[1];
  const userData = <UserData | undefined> jwt.decode(token, { complete: true })?.payload;
  if (!userData?.email) {
    return {
      statusCode: 401,
      body: JSON.stringify({
        message: 'Invalid token',
      }),
    };
  }

  try {
    const userVideos = await getUserVideos(userData.email);
    console.log('userVideos', userVideos);

    if (!userVideos || userVideos.length === 0) {
      return {
        statusCode: 404,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ error: 'User or videos not found.' }),
      };
    }

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ videos: userVideos }),
    };
  } catch (error: any) {
    console.error('Error', error);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ error: 'Internal server error' }),
    };
  }
};
