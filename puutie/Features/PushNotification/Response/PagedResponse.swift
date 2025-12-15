//
//  PagebleResponse.swift
//  puutie
//
//  Created by Gurhan on 11/29/25.
//


struct PagedResponse<T: Decodable>: Decodable {
    let content: [T];
    let page: Int;
    let size: Int;
    let totalElements: Int;
    let totalPages: Int;
    let first: Bool;
    let last: Bool;
}
