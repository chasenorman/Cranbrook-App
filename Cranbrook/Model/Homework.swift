//
//  File.swift
//  Cranbrook
//
//  Created by Chase Norman on 2/15/18.
//  Copyright © 2018 Chase Norman. All rights reserved.
//

import Foundation

struct Homework: Decodable{
    let groupname: String
    let short_description: String
    let long_description: String?
    let assignment_status: Int
}

/*{
 "groupname":"American Literature - 6",
 "section_id":81629684,"assignment_id":8468831,
 "short_description":"<i>&#65279;Gatsby</i>&#65279;: read and annotate chapter 4.",
 "date_assignedTicks":636540768000000000,
 "date_assigned":"2/13/2018 12:00 AM",
 "date_dueTicks":636543359400000000,
 "date_due":"2/15/2018 11:59 PM",
 "drop_box_late_timeTicks":636543359400000000,
 "drop_box_late_time":"2/15/2018 11:59 PM",
 "long_description":null,
 "assignment_index_id":13702992,
 "assignment_type":"Homework",
 "inc_grade_book":true,
 "publish_grade":true,
 "enroll_count":0,
 "graded_count":0,
 "drop_box_id":null,
 "drop_box_ind":false,
 "has_link":false,
 "has_download":false,
 "assignment_status":4,
 "assessment_ind":false,
 "assessment_id":null,
 "assessment_locked":false,
 "show_report":null,
 "has_grade":true,
 "local_nowTicks":636543278011600000,
 "local_now":"2/15/2018 9:43 PM",
 "major":false,
 "lti_ind":false,
 "lti_config_ind":false,
 "lti_provider_name":null,
 "discussion_ind":false,
 "share_discussion":true,
 "show_discussion_ind":false,
 "allow_discussion_attachment":true,
 "rubric_id":null,"exempt_ind":false,
 "incomplete_ind":false,
 "late_ind":false,
 "missing_ind":false
}*/
