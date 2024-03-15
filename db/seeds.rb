# coding: utf-8

User.create!(name: "管理者",
             password: "password",
             password_confirmation: "password",
             admin: true)

User.create!(name: "職員A",
             employee_number: 001,
             base_pay: 1000,
             password: "password",
             password_confirmation: "password",
             )

User.create!(name: "職員B",
             employee_number: 002,
             base_pay: 1000,
             password: "password",
             password_confirmation: "password",
             )