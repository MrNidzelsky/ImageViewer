//
//  Result.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 3/28/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import Foundation

enum Result<ResultType> {
  case results(ResultType)
  case error(Error)
}
