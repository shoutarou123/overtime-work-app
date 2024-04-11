# coding: utf-8

User.create!(name: "管理者",
             base_pay: 0,
             password: "password",
             password_confirmation: "password",
             admin: true)

User.create!(name: "山根",
             employee_number: 000,
             department: "T分署",
             job_title: "分署長",
             base_pay: 500000,
             password: "password",
             password_confirmation: "password",
             superior: true,
             report: true)

User.create!(name: "職員A",
             employee_number: 001,
             department: "T分署",
             job_title: "主任",
             base_pay: 305900,
             password: "password",
             password_confirmation: "password")

User.create!(name: "職員B",
             employee_number: 002,
             department: "T分署",
             job_title: "消防士長",
             base_pay: 401200,
             password: "password",
             password_confirmation: "password")

User.create!(name: "庶務係さとう",
             employee_number: 100,
             department: "T分署",
             job_title: "消防士長",
             base_pay: 305900,
             password: "password",
             password_confirmation: "password",
             office_staff: true)

User.create!(name: "庶務係すずき",
             employee_number: 101,
             department: "T分署",
             job_title: "消防士",
             base_pay: 305900,
             password: "password",
             password_confirmation: "password",
             office_staff: true)