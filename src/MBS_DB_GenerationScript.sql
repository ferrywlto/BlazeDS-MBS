SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `mbs_new` DEFAULT CHARACTER SET utf8 ;
USE `mbs_new` ;

-- -----------------------------------------------------
-- Table `mbs_new`.`statuscode`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`statuscode` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(20) NOT NULL ,
  `description` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`user`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`user` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `displayName` VARCHAR(50) NOT NULL COMMENT 'in case of a group, it is the group name' ,
  `description` VARCHAR(255) NULL DEFAULT NULL ,
  `status` TINYINT(3) UNSIGNED NOT NULL DEFAULT '1' ,
  `isGroup` TINYINT(1) NOT NULL DEFAULT '0' ,
  `createdAt` DATETIME NOT NULL ,
  `modifiedAt` DATETIME NOT NULL ,
  `validAt` DATETIME NULL DEFAULT NULL ,
  `expireAt` DATETIME NULL DEFAULT NULL ,
  `homeFolder` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_User_StatusCode1` (`status` ASC) ,
  INDEX `fk_user_content1` (`homeFolder` ASC) ,
  CONSTRAINT `fk_user_content1`
    FOREIGN KEY (`homeFolder` )
    REFERENCES `mbs_new`.`content` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_User_StatusCode1`
    FOREIGN KEY (`status` )
    REFERENCES `mbs_new`.`statuscode` (`id` )
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`content`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`content` (
  `id` MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(255) NULL DEFAULT NULL ,
  `creator` SMALLINT(6) UNSIGNED NULL DEFAULT '1' ,
  `status` TINYINT(3) UNSIGNED NOT NULL ,
  `parent` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL ,
  `isFolder` TINYINT(1) NOT NULL DEFAULT '0' ,
  `createdAt` DATETIME NOT NULL ,
  `modifiedAt` DATETIME NOT NULL ,
  `validAt` DATETIME NULL DEFAULT NULL ,
  `expireAt` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_ Folder_ Folder1` (`parent` ASC) ,
  INDEX `fk_ Folder_StatusCode1` (`status` ASC) ,
  INDEX `fk_Content_User1` (`creator` ASC) ,
  CONSTRAINT `fk_ Folder_ Folder1`
    FOREIGN KEY (`parent` )
    REFERENCES `mbs_new`.`content` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ Folder_StatusCode1`
    FOREIGN KEY (`status` )
    REFERENCES `mbs_new`.`statuscode` (`id` )
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Content_User1`
    FOREIGN KEY (`creator` )
    REFERENCES `mbs_new`.`user` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`session`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`session` (
  `id` VARCHAR(45) NOT NULL ,
  `ipAddress` VARCHAR(39) NOT NULL COMMENT 'length 39 used for future IPv6 consideration' ,
  `createdAt` DATETIME NOT NULL ,
  `endAt` DATETIME NULL DEFAULT NULL ,
  `user` SMALLINT(5) UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_session_user1` (`user` ASC) ,
  CONSTRAINT `fk_session_user1`
    FOREIGN KEY (`user` )
    REFERENCES `mbs_new`.`user` (`id` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`contentaccess`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`contentaccess` (
  `session` VARCHAR(45) NOT NULL ,
  `content` MEDIUMINT(8) UNSIGNED NOT NULL ,
  `startAt` DATETIME NOT NULL ,
  `endAt` DATETIME NULL DEFAULT NULL ,
  INDEX `fk_ContentAccess_Session1` (`session` ASC) ,
  INDEX `fk_ContentAccess_Content1` (`content` ASC) ,
  CONSTRAINT `fk_ContentAccess_Content1`
    FOREIGN KEY (`content` )
    REFERENCES `mbs_new`.`content` (`id` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ContentAccess_Session1`
    FOREIGN KEY (`session` )
    REFERENCES `mbs_new`.`session` (`id` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`contentcategory`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`contentcategory` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`contentdetail`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`contentdetail` (
  `content` MEDIUMINT(8) UNSIGNED NOT NULL ,
  `duration` SMALLINT(6) NULL DEFAULT NULL COMMENT 'in seconds. maximum duration is 18.2 hours.' ,
  `type` ENUM('FLV','MP4','MP3','F4V') NULL DEFAULT NULL ,
  `fileSize` BIGINT(20) NULL DEFAULT NULL COMMENT 'in MegaBytes (MB)' ,
  `resolution` VARCHAR(9) NULL DEFAULT NULL ,
  `bitrate` SMALLINT(6) NULL DEFAULT NULL COMMENT 'in kbps' ,
  `category` SMALLINT(5) UNSIGNED NULL DEFAULT NULL ,
  PRIMARY KEY (`content`) ,
  INDEX `fk_ContentDetail_Content1` (`content` ASC) ,
  INDEX `fk_ContentDetail_ContentCatagory1` (`category` ASC) ,
  CONSTRAINT `fk_ContentDetail_Content1`
    FOREIGN KEY (`content` )
    REFERENCES `mbs_new`.`content` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ContentDetail_ContentCatagory1`
    FOREIGN KEY (`category` )
    REFERENCES `mbs_new`.`contentcategory` (`id` )
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`userdetail`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`userdetail` (
  `user` SMALLINT(5) UNSIGNED NOT NULL ,
  `login` VARCHAR(45) NOT NULL ,
  `password` VARCHAR(15) NOT NULL ,
  `firstName` VARCHAR(25) NULL DEFAULT NULL ,
  `lastName` VARCHAR(25) NULL DEFAULT NULL ,
  `title` VARCHAR(30) NULL DEFAULT NULL ,
  `email` VARCHAR(50) NULL DEFAULT NULL ,
  `phone` VARCHAR(20) NULL DEFAULT NULL ,
  `birthday` DATE NULL DEFAULT NULL ,
  PRIMARY KEY (`user`) ,
  UNIQUE INDEX `login_UNIQUE` (`login` ASC) ,
  INDEX `fk_UserDetail_User1` (`user` ASC) ,
  CONSTRAINT `fk_UserDetail_User1`
    FOREIGN KEY (`user` )
    REFERENCES `mbs_new`.`user` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`contentevaluation`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`contentevaluation` (
  `user` SMALLINT(5) UNSIGNED NOT NULL ,
  `content` MEDIUMINT(8) UNSIGNED NOT NULL ,
  `evaluateAt` DATETIME NOT NULL ,
  `rate` TINYINT(3) UNSIGNED NULL DEFAULT NULL ,
  `comment` VARCHAR(255) NULL DEFAULT NULL ,
  `like` TINYINT(1) NULL DEFAULT NULL ,
  `inappropriate` TINYINT(1) NULL DEFAULT NULL ,
  INDEX `fk_ContentEvaluation_ContentDetail1` (`content` ASC) ,
  INDEX `fk_ContentEvaluation_UserDetail1` (`user` ASC) ,
  CONSTRAINT `fk_ContentEvaluation_ContentDetail1`
    FOREIGN KEY (`content` )
    REFERENCES `mbs_new`.`contentdetail` (`content` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ContentEvaluation_UserDetail1`
    FOREIGN KEY (`user` )
    REFERENCES `mbs_new`.`userdetail` (`user` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`groupassignment`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`groupassignment` (
  `group` SMALLINT(5) UNSIGNED NOT NULL ,
  `member` SMALLINT(5) UNSIGNED NOT NULL ,
  INDEX `fk_GroupMembership_User1` (`group` ASC) ,
  INDEX `fk_GroupMembership_UserDetail1` (`member` ASC) ,
  CONSTRAINT `fk_GroupMembership_User1`
    FOREIGN KEY (`group` )
    REFERENCES `mbs_new`.`user` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_GroupMembership_UserDetail1`
    FOREIGN KEY (`member` )
    REFERENCES `mbs_new`.`userdetail` (`user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`log`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`log` (
  `session` VARCHAR(45) NOT NULL ,
  `date` DATETIME NOT NULL ,
  `event` VARCHAR(255) NULL DEFAULT NULL ,
  INDEX `fk_table1_Session1` (`session` ASC) ,
  CONSTRAINT `fk_table1_Session1`
    FOREIGN KEY (`session` )
    REFERENCES `mbs_new`.`session` (`id` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`playlist`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`playlist` (
  `id` MEDIUMINT(9) NOT NULL ,
  `name` VARCHAR(255) NULL DEFAULT NULL ,
  `description` VARCHAR(255) NULL DEFAULT NULL ,
  `category` TINYINT(4) NOT NULL ,
  `type` ENUM('Video','Audio','Image','Mixed') NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`playlistcontent`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`playlistcontent` (
  `playlist` SMALLINT(6) NULL DEFAULT NULL ,
  `content` VARCHAR(255) NULL DEFAULT NULL ,
  `sequence` TINYINT(4) NULL DEFAULT NULL )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`role`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`role` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(30) NOT NULL ,
  `description` TEXT NULL DEFAULT NULL ,
  `userAdd` TINYINT(1) NOT NULL DEFAULT '0' ,
  `userDel` TINYINT(1) NOT NULL DEFAULT '0' ,
  `userMod` TINYINT(1) NOT NULL DEFAULT '0' ,
  `userView` TINYINT(1) NOT NULL DEFAULT '0' ,
  `contentAdd` TINYINT(1) NOT NULL DEFAULT '0' ,
  `contentDel` TINYINT(1) NOT NULL DEFAULT '0' ,
  `contentMod` TINYINT(1) NOT NULL DEFAULT '0' ,
  `contentView` TINYINT(1) NOT NULL DEFAULT '0' ,
  `folderAdd` TINYINT(1) NOT NULL DEFAULT '0' ,
  `folderDel` TINYINT(1) NOT NULL DEFAULT '0' ,
  `folderMod` TINYINT(1) NOT NULL DEFAULT '0' ,
  `folderView` TINYINT(1) NOT NULL DEFAULT '0' ,
  `groupAdd` TINYINT(1) NOT NULL DEFAULT '0' ,
  `groupDel` TINYINT(1) NOT NULL DEFAULT '0' ,
  `groupMod` TINYINT(1) NOT NULL DEFAULT '0' ,
  `groupView` TINYINT(1) NOT NULL DEFAULT '0' ,
  `reportAdd` TINYINT(1) NOT NULL DEFAULT '0' ,
  `reportDel` TINYINT(1) NOT NULL DEFAULT '0' ,
  `reportView` TINYINT(1) NOT NULL DEFAULT '0' ,
  `mbs_newBackup` TINYINT(1) NOT NULL DEFAULT '0' ,
  `mbs_newLDAP` TINYINT(1) NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mbs_new`.`roleassignment`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mbs_new`.`roleassignment` (
  `user` SMALLINT(5) UNSIGNED NOT NULL ,
  `content` MEDIUMINT(8) UNSIGNED NOT NULL ,
  `role` SMALLINT(5) UNSIGNED NOT NULL ,
  `validAt` DATETIME NOT NULL ,
  `expireAt` DATETIME NULL DEFAULT NULL ,
  `status` TINYINT(3) UNSIGNED NOT NULL ,
  INDEX `fk_RoleAssignment_User1` (`user` ASC) ,
  INDEX `fk_RoleAssignment_Content1` (`content` ASC) ,
  INDEX `fk_RoleAssignment_Role1` (`role` ASC) ,
  INDEX `fk_RoleAssignment_StatusCode1` (`status` ASC) ,
  CONSTRAINT `fk_RoleAssignment_Content1`
    FOREIGN KEY (`content` )
    REFERENCES `mbs_new`.`content` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_RoleAssignment_Role1`
    FOREIGN KEY (`role` )
    REFERENCES `mbs_new`.`role` (`id` )
    ON UPDATE CASCADE,
  CONSTRAINT `fk_RoleAssignment_StatusCode1`
    FOREIGN KEY (`status` )
    REFERENCES `mbs_new`.`statuscode` (`id` )
    ON UPDATE CASCADE,
  CONSTRAINT `fk_RoleAssignment_User1`
    FOREIGN KEY (`user` )
    REFERENCES `mbs_new`.`user` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- procedure _getParent
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `_getParent`(
IN uid SMALLINT,
IN cid MEDIUMINT, OUT returnCode TINYINT)
BEGIN
DECLARE p MEDIUMINT;
DECLARE c MEDIUMINT;

SELECT * FROM `RoleAssignment` WHERE `user` = uid AND `content` = cid;
IF FOUND_ROWS() = 1 THEN
    SELECT * FROM `RoleAssignment` ra, `role` r 
    WHERE ra.`user` = uid 
    AND ra.`content` = cid 
    AND ra.`role` = r.`id`;
    
    SET returnCode = 0;
ELSE
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp (cid MEDIUMINT, pid MEDIUMINT) ENGINE=MEMORY;

    SET @c = cid;
    SELECT `parent` INTO @p FROM `content` WHERE `id` = @c LIMIT 1;
    IF @p IS NULL THEN SET returnCode = -1;
    ELSE
        WHILE @p IS NOT NULL DO
            SET @c = @p;
            -- INSERT INTO tmp VALUES (cid, @p);
            SELECT * FROM `RoleAssignment` WHERE `user` = uid AND `content` = @c;
            IF FOUND_ROWS() = 1 THEN
                SELECT * FROM `RoleAssignment` ra, `role` r 
                WHERE ra.`user` = uid 
                AND ra.`content` = cid 
                AND ra.`role` = r.`id`;
                
                SET returnCode = 0;
            ELSE
                SELECT `parent` INTO @p FROM `content` WHERE `id` = @c LIMIT 1;
            END IF;
        END WHILE;
    END IF;
    INSERT INTO tmp VALUES (@c, NULL);

    SELECT tmp;

    IF FOUND_ROWS() > 0 THEN
        SET returnCode = 0;
    ELSE
        SET returnCode = -1;
    END IF;

    DROP TABLE tmp;
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure _getRoleFromAssignment
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `_getRoleFromAssignment`(
IN userID SMALLINT,
IN contentID MEDIUMINT,
OUT returnCode TINYINT)
BEGIN
    DECLARE roleID TINYINT;
    SET returnCode = -1;
    
    SELECT `role` INTO @roleID FROM `roleassignment`
    WHERE `user` = userID AND `content` = contentID;
    
    IF FOUND_ROWS() = 1 THEN
      SELECT * FROM `roleAssignment` WHERE `id` = @roleID;
    
      IF FOUND_ROWS() = 1 THEN
        SET returnCode = 0;
      END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure _scanContentHierarchyForRole
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `_scanContentHierarchyForRole`(IN userID SMALLINT, IN contentID MEDIUMINT, IN returnCode TINYINT)
BEGIN
  DECLARE tmpParent MEDIUMINT;
  DECLARE tmpContent MEDIUMINT;
  DECLARE finalContent MEDIUMINT;

  SELECT * FROM `roleassignment` WHERE `user` = userID AND `content` = contentID;
  
  IF found_rows() = 1 THEN
    SELECT * FROM `roleassignment` ra, `role` r
    WHERE ra.`user` = userID 
    AND ra.`content` = contentID
    AND ra.`role` = r.`id`;
    SET returnCode = 0;
  ELSE
    SET @finalContent = NULL;
    SET @tmpContent = contentID;
    SELECT @tmpParent = `parent` FROM `content` WHERE `id` = @tmpContent LIMIT 1;
    IF @tmpParent IS NOT NULL THEN
      parentLoop: WHILE @tmpParent IS NOT NULL DO
        SET @tmpContent = @tmpParent;
        SELECT * FROM `roleassignment` WHERE `user` = userID AND `content` = @tmpContent;
        IF found_rows() = 1 THEN
          SET @finalContent = @tmpContent;
          LEAVE parentLoop;
        ELSE
          SELECT @tmpParent = `parent` FROM `content` WHERE `id` = @tmpContent LIMIT 1;
        END IF;
      END WHILE;
      IF @finalContent IS NULL THEN
        SET returnCode = -1;
      ELSE
        SELECT * FROM `roleassignment` ra, `role` r
        WHERE ra.`user` = userID 
        AND ra.`content` = @finalContent
        AND ra.`role` = r.`id`;
        SET returnCode = 0;
      END IF;
    ELSE
      SET returnCode = -1;
    END IF;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure _updateGroupAssignment
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `_updateGroupAssignment`(IN  groupID      SMALLINT,
                                             IN  userID       SMALLINT,
                                             OUT returnCode   BOOL)
BEGIN
      SET returnCode = -1;
      
      SELECT `group`
        FROM `GroupAssignment`
       WHERE `group` = groupID AND `user` = userID;

      IF FOUND_ROWS() = 0
      THEN
         INSERT INTO `GroupAssignment`(`group`, `user`) VALUES (groupID, userID);
      ELSE
         UPDATE `GroupAssignment`SET `group` = groupID, `user` = userID;
      END IF;
      
      IF ROW_COUNT() = 1 THEN SET returnCode = 0; END IF;
   END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addContent
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `addContent`(
IN name VARCHAR(45), 
IN description VARCHAR(255), 
IN creator SMALLINT, 
IN status TINYINT, 
IN parent MEDIUMINT, 
IN validAt DATETIME, 
IN expireAt DATETIME, 
IN duration SMALLINT, 
IN type ENUM('FLV','MP4','MP3','F4V'), 
IN fileSize SMALLINT, 
IN resolution VARCHAR(9), 
IN bitrate SMALLINT, 
IN category SMALLINT, 
OUT returnCode TINYINT,
OUT newID MEDIUMINT)
root:BEGIN
  DECLARE now DATETIME;
  
  SET @now = now();
  SET returnCode = -1;
  
  START TRANSACTION;
  INSERT INTO 
  content (`name`, `description`, `creator`, `status`, `parent`, `isFolder`, `createdAt`, `modifiedAt`, `validAt`, `expireAt`)
  VALUES  (name, description, creator, status, parent, FALSE, @now, @now, validAt, expireAt);

  IF ROW_COUNT() = 1 THEN
    SET newID = LAST_INSERT_ID();
    
    INSERT INTO contentdetail (`content`, `duration`, `type`, `fileSize`, `resolution`, `bitrate`, `category`)
    VALUES (id, duration, type, fileSize, resolution, bitrate, category);
    
    IF ROW_COUNT() = 1 THEN
        SET returnCode = 0;
        COMMIT;
        LEAVE root;
    END IF;
  END IF;
  ROLLBACK;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addContentCategory
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `addContentCategory`(
IN name VARCHAR(45),
IN description VARCHAR(255),
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  INSERT INTO ContentCategory (`name`, `description`) VALUES (name,description);
  
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addFolder
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `addFolder`(
IN name VARCHAR(45), 
IN description VARCHAR(255), 
IN creator SMALLINT, 
IN status TINYINT, 
IN parent MEDIUMINT, 
IN validAt DATETIME, 
IN expireAt DATETIME, 
OUT returnCode TINYINT, 
OUT newFolderID MEDIUMINT)
BEGIN
  DECLARE now DATETIME;
  DECLARE id SMALLINT;
  SET @now = now();
  SET returnCode = -1;
  
  INSERT INTO 
  content (`name`, `description`, `creator`, `status`, `parent`, `isFolder`, `createdAt`, `modifiedAt`, `validAt`, `expireAt`)
  VALUES  (name, description, creator, status, parent, TRUE, @now, @now, validAt, expireAt);
	
  IF ROW_COUNT() = 1 THEN
		SET newFolderID = LAST_INSERT_ID();
    SET returnCode = 0;
  END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addGroup
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `addGroup`(IN displayName VARCHAR(50), 
 IN description VARCHAR(255),
 IN validAt DATETIME,
 IN expireAt DATETIME,
 OUT returnCode TINYINT,
 OUT newGroupID SMALLINT)
root:BEGIN
DECLARE now DATETIME;
DECLARE id SMALLINT;
DECLARE tmp TINYINT;

SET returnCode = -1;
START TRANSACTION;
    SET @now = now();
    INSERT INTO User (`displayName`, `description`, `status`, `isGroup`,  `createdAt`, `modifiedAt`, `validAt`, `expireAt`)
    VALUES (displayName, description, 1, TRUE, @now, @now, validAt, expireAt);

    IF ROW_COUNT() = 1 THEN
        SET newGroupID = LAST_INSERT_ID();
        CALL createUserHomeFolder(newGroupID,@tmp);
        IF @tmp = 0 THEN
          SET returnCode = 0;
          COMMIT;
          LEAVE root;
        END IF;
    END IF;
ROLLBACK;    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addGroupAssignment
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `addGroupAssignment`(IN groupID SMALLINT,
 IN userID SMALLINT,
 OUT returnCode TINYINT)
BEGIN
SET returnCode = -1;

INSERT INTO `GroupAssignment` (`group`,`user`) 
VALUES (groupID, userID);

IF ROW_COUNT() = 1 THEN
  SET returnCode = 0;  
END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addRole
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `addRole`(
IN name varchar(30),
IN description text,
IN userAdd          tinyint(1),
IN userDel          tinyint(1),
IN userMod          tinyint(1),
IN userView         tinyint(1),
IN contentAdd       tinyint(1),
IN contentDel       tinyint(1),
IN contentMod       tinyint(1),
IN contentView      tinyint(1),
IN folderAdd        tinyint(1),
IN folderDel        tinyint(1),
IN folderMod        tinyint(1),
IN folderView       tinyint(1),
IN groupAdd         tinyint(1),
IN groupDel         tinyint(1),
IN groupMod         tinyint(1),
IN groupView        tinyint(1),
IN reportAdd        tinyint(1),
IN reportDel        tinyint(1),
IN reportView       tinyint(1),
IN mbs_newBackup    tinyint(1),
IN mbs_newLDAP      tinyint(1),
OUT returnCode TINYINT,
OUT newRoleID SMALLINT)
BEGIN
  SET returnCode = -1;
   
    INSERT INTO `role` (
     `name`,
     `description`,
     `userAdd`,
     `userDel`,
     `userMod`,
     `userView`,
     `contentAdd`,
     `contentDel`,
     `contentMod`,
     `contentView`,
     `folderAdd`,
     `folderDel`,
     `folderMod`,
     `folderView`,
     `groupAdd`,
     `groupDel`,
     `groupMod`,
     `groupView`,
     `reportAdd`,
     `reportDel`,
     `reportView`,
     `mbs_newBackup`,
     `mbs_newLDAP`) 
     VALUES ( 
      name,
      description, 
      userAdd,          
      userDel,          
      userMod,          
      userView,         
      contentAdd,       
      contentDel,       
      contentMod,       
      contentView,      
      folderAdd,        
      folderDel,        
      folderMod,        
      folderView,       
      groupAdd,         
      groupDel,         
      groupMod,         
      groupView,        
      reportAdd,        
      reportDel,        
      reportView,
      mbs_newBackup,
      mbs_newLDAP);
    
  IF ROW_COUNT() = 1 THEN
    SET newRoleID = LAST_INSERT_ID();
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addRoleAssignment
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `addRoleAssignment`(IN  user         SMALLINT,
                                  IN  content      MEDIUMINT,
                                  IN  role         TINYINT,
                                  IN  validAt      DATETIME,
                                  IN  expireAt     DATETIME,
                                  IN  status       TINYINT,
                                  OUT returnCode   TINYINT)
BEGIN
    SET returnCode = -1;
      SELECT * FROM roleassignment WHERE `user` = userID AND `content` = contentID;

      IF FOUND_ROWS() = 0 THEN
         INSERT INTO `roleassignment` VALUES (user, content, role, validAt, expireAt, status);

         IF ROW_COUNT() = 1 THEN SET returnCode = 0; END IF;
      ELSE
         IF FOUND_ROWS() = 1 THEN
            UPDATE `roleAssignment` SET 
              `role` = role,
              `validAt` = validAt,
              `expireAt` = expireAt,
              `status` = status
              WHERE `user` = userID AND `content` = contentID;

            IF ROW_COUNT() = 1 THEN SET returnCode = 0; END IF;
         END IF;
      END IF;
   END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addStatusCode
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `addStatusCode`(
IN name VARCHAR(20), 
IN description VARCHAR(255), 
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  INSERT INTO StatusCode (`name`, `description`) 
  VALUES (name, description);

  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addUser
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `addUser`(IN login VARCHAR(45), 
 IN passwd VARCHAR(15),
 IN firstName VARCHAR(25),
 IN lastName VARCHAR(25),
 IN title VARCHAR(30),
 IN email VARCHAR(50),
 IN phone VARCHAR(20),
 IN birthday DATE,
 IN displayName VARCHAR(50), 
 IN description VARCHAR(255),
 IN validAt DATETIME,
 IN expireAt DATETIME,
 OUT returnCode TINYINT)
root:BEGIN
DECLARE now DATETIME;
DECLARE newUserID SMALLINT;
DECLARE temp TINYINT;

SET returnCode = -1;
SET @now = now();

-- search for user existence
SELECT COUNT(`id`) INTO @temp FROM UserDetail WHERE `login` = login;
IF @temp = 0 THEN
    -- add only if no same login found
    START TRANSACTION;
    INSERT INTO User (`displayName`, `description`, `status`, `isGroup`, `createdAt`, `modifiedAt`, `validAt`, `expireAt`)
    VALUES (displayName, description, 1, FALSE, @now, @now, validAt, expireAt);

    IF ROW_COUNT() = 1 THEN 
        SET @newUserID = LAST_INSERT_ID();
        INSERT INTO UserDetail (`user`, `login`, `password`, `firstName`, `lastName`, `title`, `email`, `phone`, `birthday`)
        VALUES (@newUserID, login, passwd, firstName, lastName, title, email, phone, birthday);
        IF ROW_COUNT() = 1 THEN
            CALL createUserHomeFolder(@newUserID,@temp);
            IF @temp = 0 THEN
              SET returnCode = 0;
              COMMIT;
              LEAVE root;
            END IF;
        END IF;
    END IF;
    ROLLBACK;
    -- TRANSACTION END
END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure createUserHomeFolder
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `createUserHomeFolder`(
IN userID SMALLINT, 
OUT returnCode TINYINT)
root:BEGIN
  DECLARE tmp TINYINT;
  DECLARE folderID MEDIUMINT;
	
	SET returnCode = -1;
  SELECT * FROM 
    (SELECT `id` FROM `user` usr WHERE `id` = userID) usr,
    (SELECT `user` FROM `userdetail` usr WHERE `user` = userID) ud
  WHERE usr.`id` = ud.`user`;

  IF FOUND_ROWS() = 1 THEN
    SELECT * FROM `content` WHERE creator = 1 AND parent = 2 AND isFolder = true;

		IF FOUND_ROWS() = 0 THEN
			START TRANSACTION;
        CALL addFolder('Home', 'User home folder', 1, 1, 2, now(), NULL, @tmp, @folderID);			
        IF @tmp = 0 THEN
          CALL addRoleAssignment(userID,@folderID,1,now(),null,1,@tmp);
          IF @tmp = 0 THEN
            COMMIT;
            SET returnCode = 0;
            LEAVE root;
          END IF;
        END IF;
      ROLLBACK;
		END IF;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delContent
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delContent`(
IN contentID VARCHAR(50), 
 OUT returnCode TINYINT)
root:BEGIN
  SET returnCode = -1;

  DELETE FROM `content` WHERE `id` = contentID AND `isFolder` = false;
  
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delContentCategory
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delContentCategory`(IN contentID SMALLINT,
 OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  DELETE FROM ContentCategory WHERE id = contentID;
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delFolder
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delFolder`(IN contentID VARCHAR(50), 
 OUT returnCode TINYINT)
root:BEGIN
  SET returnCode = -1;

  DELETE FROM `content` WHERE `id` = contentID AND `isFolder` = true;
  
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delGroup
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delGroup`(IN groupID VARCHAR(50), 
 OUT returnCode TINYINT)
root:BEGIN
  SET returnCode = -1;

  DELETE FROM `user` WHERE `id` = groupID AND `isGroup` = true;
  
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delGroupAssignment
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delGroupAssignment`(IN groupID SMALLINT,
 IN userID SMALLINT,
 OUT returnCode TINYINT)
BEGIN
SET returnCode = -1;

DELETE FROM `GroupAssignment` WHERE
    `group` = groupID AND
    `user` = userID;

IF ROW_COUNT() = 1 THEN
  SET returnCode = 0;  
END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delRole
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delRole`(
IN roleID SMALLINT,
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
    DELETE FROM `role` WHERE `roleID` = roleID;
    
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delRoleAssignment
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delRoleAssignment`(IN  userID         SMALLINT,
                                  IN  contentID      MEDIUMINT,
                                  OUT returnCode   TINYINT)
BEGIN
    SET returnCode = -1;
    DELETE FROM roleassignment WHERE `user` = userID AND `content` = contentID;

    IF ROW_COUNT() = 1 THEN
      SET returnCode = 0;
    END IF;
 END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delSession
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delSession`(IN sessionID VARCHAR(255), OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  DELETE FROM Session WHERE `id` = sessionID;
    
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delStatusCode
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delStatusCode`(IN statusID TINYINT, OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  DELETE FROM `statusCode` 
  WHERE `id` = statusID;

  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delUser
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delUser`(IN groupID VARCHAR(50), 
 OUT returnCode TINYINT)
root:BEGIN
  SET returnCode = -1;

  DELETE FROM `user` WHERE `id` = groupID AND `isGroup` = false;
  
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getAllContentCategory
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getAllContentCategory`(OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  SELECT * FROM  `contentcategory`;
  
  IF FOUND_ROWS() > 0 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getContentCategory
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getContentCategory`(
IN id SMALLINT,
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  SELECT * FROM `contentcategory` WHERE `id` = @id;
  
  IF FOUND_ROWS() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getContentInfo
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getContentInfo`(
IN id MEDIUMINT,
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  SELECT * FROM `content` c, `contentDetail` d
  WHERE c.`id` = id AND c.`isFolder` = true
  AND c.`id` = d.`content`;
	
  IF FOUND_ROWS() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getFolderInfo
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getFolderInfo`(
IN id MEDIUMINT,
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  SELECT * FROM `content` WHERE `id` = id AND `isFolder` = true;
	
  IF FOUND_ROWS() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getGroupAssignmentByGroup
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getGroupAssignmentByGroup`(
IN groupID SMALLINT, 
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  SELECT `member` FROM `GroupAssignment` WHERE `groupID` = groupID;
  
  IF FOUND_ROWS() > 0 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getGroupAssignmentByUser
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getGroupAssignmentByUser`(
IN userID SMALLINT, 
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  SELECT `group` FROM `GroupAssignment` WHERE `userID` = userID;
  
  IF FOUND_ROWS() > 0 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getGroupInfo
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getGroupInfo`(
IN groupID SMALLINT, 
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;

  SELECT * FROM `User` WHERE 
  `id` = groupID AND `isGroup` = true;

  IF FOUND_ROWS() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getIDFromLogin
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getIDFromLogin`(
IN login VARCHAR(45), 
OUT returnCode TINYINT,
OUT userID SMALLINT)
BEGIN
  SET returnCode = -1;
  SET userID = -1;
  
  SELECT `user` INTO userID FROM UserDetail
  WHERE `login` = login LIMIT 1;
  
  IF userID <> -1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getRoleAssignment
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getRoleAssignment`(IN  userID         SMALLINT,
                                  IN  contentID      MEDIUMINT,
                                  OUT returnCode   TINYINT)
BEGIN
    SET returnCode = -1;
    SELECT * FROM roleassignment WHERE `user` = userID AND `content` = contentID;

    IF FOUND_ROWS() = 1 THEN
      SET returnCode = 0;
    END IF;
 END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getRoleInfo
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getRoleInfo`(
IN roleID SMALLINT,
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
    
  SELECT * FROM `role` WHERE `id` = roleID;
    
  IF FOUND_ROWS() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getSession
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getSession`(
IN sessionID VARCHAR(255), 
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  SELECT * FROM Session WHERE `id` = sessionID;
    
  IF FOUND_ROWS() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getStatusCode
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getStatusCode`(
IN statusID TINYINT, 
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  SELECT `name`, `description` FROM `StatusCode`
  WHERE `id` = statusID;

  IF FOUND_ROWS() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getUserByID
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getUserByID`(
IN userID SMALLINT,
OUT returnCode TINYINT)
BEGIN

SET returnCode = -1;

SELECT * FROM 
(SELECT * FROM `User` WHERE `id` = userID AND `isGroup` = false) user1,
(SELECT * FROM `UserDetail` WHERE `user` = userID) user2
WHERE user1.`id` = user2.`user`;

IF FOUND_ROWS() = 1 THEN
  SET returnCode = 0;
END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getUserByLogin
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `getUserByLogin`(
IN login VARCHAR(45),
OUT returnCode TINYINT)
BEGIN
DECLARE userID SMALLINT;
DECLARE temp TINYINT;

SET returnCode = -1;

CALL getIDFromLogin(login, @userID, @temp);
IF @temp = 0 THEN
  CALL getUserByID(@userID, @temp);
  IF @temp = 0 THEN
    SET returnCode = 0;
  END IF;
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `login`(
IN sessionID VARCHAR(255), 
IN login VARCHAR(45),
IN password VARCHAR(15),
OUT returnCode TINYINT)
BEGIN
    DECLARE userID SMALLINT;
    SET @userID = -1;
    SET returnCode = -1;
    
    SELECT `user` INTO @userID FROM `UserDetail` WHERE 
    `login` = login AND `password` = password LIMIT 1;
    
    IF @userID <> -1 THEN
        UPDATE `session` 
        SET 
          `user` = @userID 
        WHERE 
          `id` = sessionID AND 
          `endAt` is NULL;

        IF ROW_COUNT() = 1 THEN
            SELECT * FROM
                (SELECT 
                    userOnly.`id`, `displayName`, userOnly.`description`, code.`name` as 'status',
                    `createdAt`, `modifiedAt`, `validAt`, `expireAt` 
                 FROM 
                    (SELECT * FROM `user` WHERE `id` = @userID AND `isGroup` = FALSE) userOnly, 
                    `statuscode` code
                 WHERE
                    userOnly.`status` = code.`id`
                ) u1,
                (SELECT `user`, `firstName`, `lastName`, `title`, `email`, `phone`, `birthday` FROM `userdetail` WHERE `user` = @userID) u2
            WHERE u1.`id` = u2.`user`;
            
            IF FOUND_ROWS() = 1 THEN
              SET returnCode = 0;
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modContent
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `modContent`(
IN id SMALLINT, 
IN name VARCHAR(45), 
IN description VARCHAR(255), 
IN creator SMALLINT, 
IN status TINYINT, 
IN parent MEDIUMINT,
IN validAt DATETIME,
IN expireAt DATETIME,
IN duration SMALLINT,
IN type enum('FLV','MP4','MP3','F4V'),
IN fileSize BIGINT,
IN resolution VARCHAR(9),
IN bitrate SMALLINT,
IN category SMALLINT,
OUT returnCode TINYINT)
root:BEGIN
DECLARE now DATETIME;

SET @now = now();
SET returnCode = -1;

SELECT `id` FROM Content WHERE `id` = parent AND `isFolder` = true;
IF FOUND_ROWS() = 1 THEN
  START TRANSACTION;
  
  UPDATE Content SET 
  `name` = name,
  `description` = description,
  `creator` = creator,
  `status` = status,
  `parent` = parent,
  `modifiedAt` = @now,
  `validAt` = validAt,
  `expireAt` = expireAt
  WHERE `id` = id AND `isFolder` = true;

  IF ROW_COUNT() = 1 THEN 
    UPDATE ContentDetail SET
      `duration` = duration,
      `type` = type,
      `fileSize` = fileSize,
      `resolution` = resolution,
      `bitrate` = bitrate,
      `category` = category
    WHERE `content` = id;
    
    IF ROW_COUNT() = 1 THEN
      COMMIT;
      SET returnCode = 0;
      LEAVE root;
    END IF;
  END IF;
  
  ROLLBACK;
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modContentCategory
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `modContentCategory`(
IN contentID SMALLINT, 
IN name VARCHAR(45),
IN description VARCHAR(255), 
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  UPDATE ContentCategory
  SET 
  `name` = name,
  `description` = description
  WHERE 
  `id` = contentID;
  
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modFolder
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `modFolder`(
IN id SMALLINT, 
IN name VARCHAR(45), 
IN description VARCHAR(255), 
IN creator SMALLINT, 
IN status TINYINT, 
IN parent MEDIUMINT,
IN validAt DATETIME,
IN expireAt DATETIME,
OUT returnCode TINYINT)
BEGIN
DECLARE now DATETIME;

SET @now = now();
SET returnCode = -1;

SELECT `id` FROM Content WHERE `id` = parent AND `isFolder` = true;
IF FOUND_ROWS() = 1 THEN
  UPDATE Content SET 
  `name` = name,
  `description` = description,
  `creator` = creator,
  `status` = status,
  `parent` = parent,
  `modifiedAt` = @now,
  `validAt` = validAt,
  `expireAt` = expireAt
  WHERE `id` = id AND `isFolder` = true;

  IF ROW_COUNT() = 1 THEN 
    SET returnCode = 0;
  END IF;
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modGroup
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `modGroup`(
IN id SMALLINT, 
IN displayName VARCHAR(50), 
IN description VARCHAR(255), 
IN status TINYINT, 
IN validAt DATETIME, 
IN expireAt DATETIME, 
OUT returnCode TINYINT)
BEGIN
DECLARE now DATETIME;

SET @now = now();
SET returnCode = -1;

UPDATE User SET 
`displayName` = displayName,
`description` = description,
`status` = status, 
`modifiedAt` = @now,
`validAt` = validAt,
`expireAt` = expireAt
WHERE `id` = id AND `isGroup` = true;

IF ROW_COUNT() = 1 THEN 
  SET returnCode = 0;
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modRole
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `modRole`(
IN roleID SMALLINT,
IN name varchar(30),
IN description text,
IN userAdd          tinyint(1),
IN userDel          tinyint(1),
IN userMod          tinyint(1),
IN userView         tinyint(1),
IN contentAdd       tinyint(1),
IN contentDel       tinyint(1),
IN contentMod       tinyint(1),
IN contentView      tinyint(1),
IN folderAdd        tinyint(1),
IN folderDel        tinyint(1),
IN folderMod        tinyint(1),
IN folderView       tinyint(1),
IN groupAdd         tinyint(1),
IN groupDel         tinyint(1),
IN groupMod         tinyint(1),
IN groupView        tinyint(1),
IN reportAdd        tinyint(1),
IN reportDel        tinyint(1),
IN reportView       tinyint(1),
IN mbs_newBackup    tinyint(1),
IN mbs_newLDAP      tinyint(1),
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
    UPDATE `role` SET
     `name` = name,
     `description` = description,
     `userAdd` = userAdd,
     `userDel` = userDel,
     `userMod` = userMod,
     `userView` = userView,
     `contentAdd` = contentAdd,
     `contentDel` = contentDel,
     `contentMod` = contentMod,
     `contentView` = contentView,
     `folderAdd` = folderAdd,
     `folderDel` = folderDel,
     `folderMod` = folderMod,
     `folderView` = folderView,
     `groupAdd` = groupAdd,
     `groupDel` = groupDel,
     `groupMod` = groupMod,
     `groupView` = groupView,
     `reportAdd` = reportAdd,
     `reportDel` = reportDel,
     `reportView` = reportView,
     `mbs_newBackup` = mbs_newBackup,
     `mbs_newLDAP` = mbs_newLDAP
    WHERE `roleID` = roleID;
    
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modStatusCode
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `modStatusCode`(
IN statusID TINYINT, 
IN name VARCHAR(20), 
IN description VARCHAR(255), 
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;
  
  UPDATE StatusCode
  SET `name` = name, `description` = description
  WHERE `id` = statusID;
  
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modUser
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `modUser`(
IN id SMALLINT, 
IN login VARCHAR(45), 
IN passwd VARCHAR(15), 
IN firstName VARCHAR(25), 
IN lastName VARCHAR(25), 
IN title VARCHAR(30), 
IN email VARCHAR(50), 
IN phone VARCHAR(20), 
IN birthday DATE, 
IN displayName VARCHAR(50), 
IN description VARCHAR(255), 
IN status TINYINT, 
IN validAt DATETIME, 
IN expireAt DATETIME, 
OUT returnCode TINYINT)
BEGIN
DECLARE now DATETIME;
DECLARE id SMALLINT;
DECLARE temp TINYINT;

SET @now = now();
SET returnCode = -1;

-- search for user existence
SELECT COUNT(`usr`.`id`) INTO @temp FROM UserDetail usrD, User usr 
WHERE `usrD`.`login` = login 
AND `usr`.`id` = `usrD`.`user`;

IF @temp = 0 THEN
    -- add only if no same login found
    START TRANSACTION;
    UPDATE User SET 
    `displayName` = displayName,
    `description` = description,
    `status` = status, 
    `modifiedAt` = @now,
    `validAt` = validAt,
    `expireAt` = expireAt
    WHERE `id` = id AND `isGroup` = false;

    IF ROW_COUNT() = 1 THEN 
        UPDATE UserDetail SET
        `login` = login,
        `password` = password,
        `firstName` = firstName,
        `lastName` = lastName,
        `title` = title,
        `email` = email,
        `phone` = phone,
        `birthday` = birthday
        WHERE `user` = id;

        IF ROW_COUNT() = 1 THEN
          SET returnCode = 0;
          COMMIT;
        END IF;
    END IF;
    ROLLBACK;
    -- TRANSACTION END
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sessionEnd
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `sessionEnd`(
IN sessionID VARCHAR(255), OUT returnCode TINYINT)
BEGIN    
  SET returnCode = -1;
  
  UPDATE Session SET endAt = now() WHERE id = sessionID;
    
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sessionNew
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `sessionNew`(
IN sessionID VARCHAR(255), 
IN ipAddress VARCHAR(39), 
OUT returnCode TINYINT)
BEGIN
  DECLARE now DATETIME;
  SET @now = now();
  SET returnCode = -1;
  
  INSERT INTO Session (`id`, `user`, `ipAddress`, `createdAt`) 
  VALUES (sessionID, 2, ipAddress, @now);
    
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sessionUpgrade
-- -----------------------------------------------------

DELIMITER $$
USE `mbs_new`$$
CREATE DEFINER=`root`@`%` PROCEDURE `sessionUpgrade`(
IN sessionID VARCHAR(255), 
IN userID SMALLINT, 
OUT returnCode TINYINT)
BEGIN
  SET returnCode = -1;

  UPDATE `Session` SET `user` = userID WHERE `id` = sessionID;
    
  IF ROW_COUNT() = 1 THEN
    SET returnCode = 0;  
  END IF;
END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
