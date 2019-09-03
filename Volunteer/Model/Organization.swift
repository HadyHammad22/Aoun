//
//  Organization.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/1/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class Organization{
    
    var name:String?
    var img:String?
    var info:String?
    var phone:String?
    var email:String?
    var address:String?
    
    init(name: String,img: String,info: String,phone: String,email: String,address: String) {
        self.name = name
        self.img = img
        self.info = info
        self.phone = phone
        self.email = email
        self.address = address
    }
    
    static func loadOrganizations()-> [Organization]{
        var listOfOrg = [Organization]()
        
        listOfOrg.append(Organization(name: "The Magdy Yaqoub Heart Foundation", img: "magdy", info: "The famous Aswan-based medical center came top of the list. Celebrated for its advanced technology and expansive vision, the MYF aims to supply treatment for heart disease to one of the poorest regions of Egypt. In 2014, the Egyptian public delved into their pockets and produced around LE517 million to support the work of the foundation. So far, between 2015-16, donations have reached LE620 ", phone: "+202 273 651 66", email: "info@myf-egypt.org",address: "7 Aziz Abaza St, Zamalek"))
        
        listOfOrg.append(Organization(name: "Misr Al-Kheir Foundation", img: "kheir", info: "The organization does work in a wide range of sectors, from education, to health, to scientific research and social services. This year Misr Al-Kheir has engaged in debt-repayment projects, helping underprivileged and vulnerable women to find sources of income and be acquitted of their debts. In 2014, more than LE346 million were donated to the organization.", phone: "16140", email: "info@misrelkheir.org",address: "4 Alahram St-El Nafoura Square, Cairo "))
        
        listOfOrg.append(Organization(name: "The Egyptian Food Bank", img: "foodBank", info: "The EFB was set up in 2006 by a group of businessmen with a vision to put an end to malnutrition in Egypt by 2020. The charity now addresses issues of widespread hunger and food wastage through feeding programs, education and development projects. They collected more than LE140 million from the people of Egypt in 2014.", phone: "(202+)-25844200", email: "Egypt_Food@gmail.com",address: "Block 44, Gamal Abdel Nasser Axis, Cairo"))
        
        listOfOrg.append(Organization(name: "Orman Charity Association", img: "orman", info: "The NGO specializes in development in Egypt. Their work aims to equip individuals and communities in Egypt's most deprived areas through education, employment programs and health work. Donations to Orman reached LE107 million in 2014.", phone: "01099941311", email: "info@orman.org",address: "300 Buildings Montaser-Talbia-Haram"))
        
        listOfOrg.append(Organization(name: "57357 Children's cancer hospital foundation", img: "cancer", info: "This state-of-the-art, specialist children's hospital is one of the few of its kind in the world. Without the donations of businesses and the public, the remarkable building could not have been built in the first place, and it continues to receive huge support. Roughly LE15 million were pledged to the hospital in 2014. The hospital provides breakthrough treatment to young cancer patients from Egypt and the wider region.", phone: "(202) 25351500 ", email: "info@57357.com",address: "El-Madbah El-Kadeem Yard–El-Saida Zenab"))
        
        listOfOrg.append(Organization(name: "Resala Charity Organization", img: "resala", info: "It has been in Egypt since 2000. They have many offices all over Egypt, represented in more than 60 branches. They have more than 33 Major aspects for donations. Recently they’re promoting for winter blankets and clothes and it’s called “Sak El-Shita”", phone: "19450", email: "contact_us@resala.org",address: "11 Mossadeq St Near Ibn Sina Hospital"))
        
        listOfOrg.append(Organization(name: "Ahl Masr Foundation", img: "burn", info: "Ahl Masr is the first Non-Profit Organization in Egypt and the Middle East to focus on Burn prevention and treatment. It was founded in 2013 providing free treatment and care to Burn patients. Ahl Masr are always trying to support Burn victims. It was why some of the stars supported them through a music video 6 months ago.", phone: "0223243750", email: "info@ahlmasr.org",address: "19 Akhnaton Street 5th District, Cairo"))
        
        listOfOrg.append(Organization(name: "Al Joud Foundation", img: "joud", info: "It’s founded since 2015 with a clear objective to help people. What makes Al Joud unique is how they educate everyone on working towards humanity through our daily life with simple acts of kindness.Since 2015 Al Joud Foundation started helping Sinbillawain Hospital by getting equipments needed. Till now they donated 2 million EGP and they are still in action.", phone: "16441", email: "info@aljoud-ngo.com",address: "38 El Hassan Street Off Sudan Dokki, Giza"))
        
        
        return listOfOrg
    }
    
}
