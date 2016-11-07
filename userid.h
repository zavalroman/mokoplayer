/*
 * userid.h
 *  get user info from OS
 *
 * thanks for firststeps.ru/linux/r.php?13
 */

#ifndef USERID_H
#define USERID_H

#include <QDebug>

#include <iostream>
#include <stdlib.h>
//#include <unistd.h>
#include <sys/types.h>

#ifdef IBPP_LINUX
    #include <unistd.h>
    #include <pwd.h>
#endif
#ifdef IBPP_WINDOWS
    #include <shlobj.h>
#endif

class UserId
{
public:
    UserId()
    {
#ifdef IBPP_LINUX
        userId = getuid();
        userInfo = getpwuid ( userId );
#endif
#ifdef IBPP_WINDOWS
        if (SUCCEEDED(SHGetFolderPathA(NULL, CSIDL_PROFILE, NULL, 0, path))) {

            //std::stringstream ss;
            //ss << path;
            qDebug() << "win_home" << path;
        }
#endif
    }

    char* getHome()
    {
#ifdef IBPP_LINUX
        return userInfo->pw_dir;
#endif
#ifdef IBPP_WINDOWS
        return NULL;
#endif
    }

private:
#ifdef IBPP_LINUX
    struct passwd *userInfo;
    uid_t userId;
#endif
#ifdef IBPP_WINDOWS
    char path[MAX_PATH];
#endif
};

#endif
