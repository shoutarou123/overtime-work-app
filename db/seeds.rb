# coding: utf-8

User.create!(name: "管理者",
             password: "password",
             base_pay: 305900,
             password_confirmation: "password",
             admin: true)

User.create!(name: "所属長",
             employee_number: 000,
             department: "A署",
             job_title: "署長",
             base_pay: 500000,
             password: "password",
             password_confirmation: "password",
             superior: true)

User.create!(name: "職員A",
             employee_number: 001,
             department: "A署",
             job_title: "主任",
             base_pay: 305900,
             password: "password",
             password_confirmation: "password")

User.create!(name: "当番長",
             employee_number: 002,
             department: "A署",
             job_title: "士",
             base_pay: 401200,
             password: "password",
             password_confirmation: "password")