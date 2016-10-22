/*
 * userid.h
 *  get user info from OS
 * 
 * thanks for firststeps.ru/linux/r.php?13
 */

#ifndef USERID_H
#define USERID_H

#include <iostream>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>

class UserId
{
public:
    UserId()
	{
		userId = getuid();
		userInfo = getpwuid ( userId );
        /*
        if ( userInfo != NULL ) {
            printf ( "user home dir = '%s'\n ", userInfo -> pw_dir );
        } else {
            std::cout << " user HOME var  = " <<  getenv ( "HOME" ) << std::endl;
		}
        */
	}
	
    char* getHome()
    {
        return userInfo->pw_dir;
    }
	
private:
	struct passwd *userInfo;
	uid_t userId;
};

#endif
