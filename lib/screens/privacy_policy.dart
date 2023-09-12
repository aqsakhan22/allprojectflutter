import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "PRIVACY POLICY",
            style: TextStyle(fontSize: 18),
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Column(
                children: [
                  Text(
                    "At Run With, accessible from www.runwith.io, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Run With and how we use it."
                    "\n \nIf you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us."
                    "\n \nThis Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Run With. This policy is not applicable to any information collected offline or via channels other than this website. Our Privacy Policy was created with the help of the Free Privacy Policy Generator."
                    "\m \n Consent"
                    "\n \nBy using our website, you hereby consent to our Privacy Policy and agree to its terms."
                    "\n \nInformation we collect"
                    "\n \nThe personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information."
                    "\n \nIf you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide."
                    "\n \nWhen you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number."
                    "\n \nHow we use your information"
                    "\n \nWe use the information we collect in various ways, including to:",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.4),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: const Text(
                              '•',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Provide, operate, and maintain our website",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: const Text(
                              '•',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Improve, personalize, and expand our website",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: const Text(
                              '•',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Understand and analyze how you use our website",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: const Text(
                              '•',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Develop new products, services, features, and functionality",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: const Text(
                              '•',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the website, and for marketing and promotional purposes",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: const Text(
                              '•',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Send you emails",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: const Text(
                              '•',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Find and prevent fraud",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "Log Files\n"
                        "Run With follows a standard procedure of using log files. These files log visitors when they visit websites. All hosting companies do this and a part of hosting services' analytics. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the site, tracking users' movement on the website, and gathering demographic information."
                    "\n \nCookies and Web Beacons"
                    "\nLike any other website, Run With uses 'cookies'. These cookies are used to store information including visitors' preferences, and the pages on the website that the visitor accessed or visited. The information is used to optimize the users' experience by customizing our web page content based on visitors' browser type and/or other information."
                    "\n \nGoogle DoubleClick DART Cookie"
                    "\nGoogle is one of a third-party vendor on our site. It also uses cookies, known as DART cookies, to serve ads to our site visitors based upon their visit to www.website.com and other sites on the internet. However, visitors may choose to decline the use of DART cookies by visiting the Google ad and content network Privacy Policy at the following URL – https://policies.google.com/technologies/ads"
                    "\n \nAdvertising Partners Privacy Policies"
                    "\nYou may consult this list to find the Privacy Policy for each of the advertising partners of Run With."
                    "\n \nThird-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on Run With, which are sent directly to users' browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit."
                    "\n \nNote that Run With has no access to or control over these cookies that are used by third-party advertisers."
                    "\n \nThird Party Privacy Policies"
                    "\nRun With's Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options."
                    "\n \nYou can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers' respective websites."
                    "\n \nCCPA Privacy Rights (Do Not Sell My Personal Information)"
                    "\nUnder the CCPA, among other rights, California consumers have the right to:"
                    "\n \nRequest that a business that collects a consumer's personal data disclose the categories and specific pieces of personal data that a business has collected about consumers."
                    "\n \nRequest that a business delete any personal data about the consumer that a business has collected."
                    "\n \nRequest that a business that sells a consumer's personal data, not sell the consumer's personal data."
                    "\n \nIf you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us."
                    "\n \nGDPR Data Protection Rights"
                    "\nWe would like to make sure you are fully aware of all of your data protection rights. Every user is entitled to the following:"
                    "\n \nThe right to access – You have the right to request copies of your personal data. We may charge you a small fee for this service."
                    "\n \nThe right to rectification – You have the right to request that we correct any information you believe is inaccurate. You also have the right to request that we complete the information you believe is incomplete."
                    "\n \nThe right to erasure – You have the right to request that we erase your personal data, under certain conditions."
                    "\n \nThe right to restrict processing – You have the right to request that we restrict the processing of your personal data, under certain conditions."
                    "\n \nThe right to data portability – You have the right to request that we transfer the data that we have collected to another organization, or directly to you, under certain conditions."
                    "\n \nIf you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us."
                    "\n \nChildren's Information \nAnother part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity."
                    "\n \nRun With does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.4),
                  )
                ],
              )),
        ));
  }
}
