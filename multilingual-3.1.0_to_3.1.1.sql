ALTER TABLE  `citations` CHANGE COLUMN `assoc_id` submission_id bigint(20) NOT NULL DEFAULT '0';

UPDATE journal_settings SET setting_name = 'editorialTeam' WHERE setting_name = 'masthead';

DELETE FROM fs USING filter_settings fs INNER JOIN filters f ON (fs.filter_id = f.filter_id) INNER JOIN filter_groups fg ON (f.filter_group_id = fg.filter_group_id AND fg.symbolic IN ('citation=>nlm30', 'isbn=>nlm30-element-citation', 'nlm30-article-xml=>nlm23-article-xml', 'nlm30-element-citation=>isbn', 'nlm30-element-citation=>nlm30-element-citation', 'nlm30-element-citation=>nlm30-xml', 'nlm30-element-citation=>plaintext', 'nlm30=>citation', 'plaintext=>nlm30-element-citation', 'submission=>nlm23-article-xml', 'submission=>nlm30-article-xml', 'submission=>reference-list'));

DELETE FROM f USING filters f INNER JOIN filter_groups fg ON (f.filter_group_id = fg.filter_group_id AND fg.symbolic IN ('citation=>nlm30', 'isbn=>nlm30-element-citation', 'nlm30-article-xml=>nlm23-article-xml', 'nlm30-element-citation=>isbn', 'nlm30-element-citation=>nlm30-element-citation', 'nlm30-element-citation=>nlm30-xml', 'nlm30-element-citation=>plaintext', 'nlm30=>citation', 'plaintext=>nlm30-element-citation', 'submission=>nlm23-article-xml', 'submission=>nlm30-article-xml', 'submission=>reference-list'));

UPDATE metrics m, submission_file_settings sfs SET m.assoc_id = sfs.file_id WHERE m.assoc_type = 531 AND sfs.setting_name = 'old-supp-id' AND sfs.setting_value = m.assoc_id;

UPDATE journal_settings SET setting_name = 'subjectsEnabledSubmission' WHERE setting_name = 'subjectEnabledSubmission';

UPDATE journal_settings SET setting_name = 'subjectsEnabledWorkflow' WHERE setting_name = 'subjectEnabledWorkflow';

UPDATE journal_settings SET setting_name = 'subjectsRequired' WHERE setting_name = 'subjectRequired';

UPDATE review_assignments SET quality = NULL WHERE quality = 0;

#UPDATE users u, (SELECT user_id, GROUP_CONCAT(DISTINCT setting_value SEPARATOR ' ') AS groupedGossips FROM user_settings WHERE setting_name = 'gossip' AND setting_value <> '' GROUP BY user_id) us SET u.gossip = us.groupedGossips WHERE us.user_id = u.user_id;

DELETE FROM user_settings WHERE setting_name='gossip';

ALTER table users ADD gossip varchar(255) DEFAULT NULL;

DELETE n FROM notifications n LEFT JOIN announcements a ON (n.assoc_id = a.announcement_id) WHERE a.announcement_id IS NULL AND n.assoc_type = 522;


INSERT INTO issue_settings (issue_id, setting_name, setting_value, setting_type) SELECT issue_id, 'datacite::status', 'registered', 'string' FROM issue_settings WHERE setting_name = 'datacite::registeredDoi' AND (setting_value IS NOT NULL OR setting_value <> '') AND issue_id NOT IN (SELECT issue_id FROM issue_settings WHERE setting_name = 'datacite::status');

INSERT INTO submission_settings (submission_id, setting_name, setting_value, setting_type) SELECT submission_id, 'datacite::status', 'registered', 'string' FROM submission_settings WHERE setting_name = 'datacite::registeredDoi' AND (setting_value IS NOT NULL OR setting_value <> '') AND submission_id NOT IN (SELECT submission_id FROM submission_settings WHERE setting_name = 'datacite::status');

INSERT INTO submission_galley_settings (galley_id, setting_name, setting_value, setting_type) SELECT galley_id, 'datacite::status', 'registered', 'string' FROM submission_galley_settings WHERE setting_name = 'datacite::registeredDoi' AND (setting_value IS NOT NULL OR setting_value <> '') AND galley_id NOT IN (SELECT galley_id FROM submission_galley_settings WHERE setting_name = 'datacite::status');

INSERT INTO issue_settings (issue_id, setting_name, setting_value, setting_type) SELECT issue_id, 'medra::status', 'registered', 'string' FROM issue_settings WHERE setting_name = 'medra::registeredDoi' AND (setting_value IS NOT NULL OR setting_value <> '') AND issue_id NOT IN (SELECT issue_id FROM issue_settings WHERE setting_name = 'medra::status');

INSERT INTO submission_settings (submission_id, setting_name, setting_value, setting_type) SELECT submission_id, 'medra::status', 'registered', 'string' FROM submission_settings WHERE setting_name = 'medra::registeredDoi' AND (setting_value IS NOT NULL OR setting_value <> '') AND submission_id NOT IN (SELECT submission_id FROM submission_settings WHERE setting_name = 'medra::status');

INSERT INTO submission_galley_settings (galley_id, setting_name, setting_value, setting_type) SELECT galley_id, 'medra::status', 'registered', 'string' FROM submission_galley_settings WHERE setting_name = 'medra::registeredDoi' AND (setting_value IS NOT NULL OR setting_value <> '') AND galley_id NOT IN (SELECT galley_id FROM submission_galley_settings WHERE setting_name = 'medra::status');

INSERT INTO submission_settings (submission_id, setting_name, setting_value, setting_type) SELECT submission_id, 'doaj::status', 'markedRegistered', 'string' FROM submission_settings WHERE setting_name = 'doaj::registered' AND (setting_value IS NOT NULL OR setting_value <> '') AND submission_id NOT IN (SELECT submission_id FROM submission_settings WHERE setting_name = 'doaj::status');
