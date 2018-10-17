/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Cocoa

class ViewController: NSViewController {

  @IBOutlet weak var statusLabel: NSTextField!
  @IBOutlet weak var tableView: NSTableView!

  let sizeFormatter = ByteCountFormatter()
  var directory: Directory?
  var directoryItems: [Metadata]?
  var sortOrder = Directory.FileOrder.Name
  var sortAscending = true

  override func viewDidLoad() {
    super.viewDidLoad()
    statusLabel.stringValue = ""

    tableView.delegate = self
    tableView.dataSource = self

    tableView.target = self
    tableView.doubleAction = #selector(tableViewDoubleClick(_:))

    let descriptorName = NSSortDescriptor(key: Directory.FileOrder.Name.rawValue, ascending: true)
    let descriptorDate = NSSortDescriptor(key: Directory.FileOrder.Date.rawValue, ascending: true)
    let descriptorSize = NSSortDescriptor(key: Directory.FileOrder.Size.rawValue, ascending: true)

    tableView.tableColumns[0].sortDescriptorPrototype = descriptorName
    tableView.tableColumns[1].sortDescriptorPrototype = descriptorDate
    tableView.tableColumns[2].sortDescriptorPrototype = descriptorSize
  }

  override var representedObject: Any? {
    didSet {
      if let url = representedObject as? URL {
        directory = Directory(folderURL: url)
        reloadFileList()
      }
    }
  }

  func reloadFileList() {
    directoryItems = directory?.contentsOrderedBy(sortOrder, ascending: sortAscending)
    tableView.reloadData()
  }

  func updateStatus() {

    let text: String

    let itemsSelected = tableView.selectedRowIndexes.count

    if (directoryItems == nil) {
      text = "No Items"
    }
    else if(itemsSelected == 0) {
      text = "\(directoryItems!.count) items"
    }
    else {
      text = "\(itemsSelected) of \(directoryItems!.count) selected"
    }

    statusLabel.stringValue = text
  }

  func tableViewDoubleClick(_ sender:AnyObject) {
    // 1
    guard tableView.selectedRow >= 0,
      let item = directoryItems?[tableView.selectedRow] else {
        return
    }

    if item.isFolder {
      representedObject = item.url as Any
    } else {
      NSWorkspace.shared().open(item.url as URL)
    }
  }

}


extension ViewController: NSTableViewDataSource {

  func numberOfRows(in tableView: NSTableView) -> Int {
    return directoryItems?.count ?? 0
  }

  func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
    guard let sortDescriptor = tableView.sortDescriptors.first else {
      return
    }

    if let order = Directory.FileOrder(rawValue: sortDescriptor.key!) {
      sortOrder = order
      sortAscending = sortDescriptor.ascending
      reloadFileList()
    }
  }

}

extension ViewController: NSTableViewDelegate {

  fileprivate enum CellIdentifiers {
    static let NameCell = "NameCellID"
    static let DateCell = "DateCellID"
    static let SizeCell = "SizeCellID"
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

    var image: NSImage?
    var text: String = ""
    var cellIdentifier: String = ""

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .long

    guard let item = directoryItems?[row] else {
      return nil
    }

    if tableColumn == tableView.tableColumns[0] {
      image = item.icon
      text = item.name
      cellIdentifier = CellIdentifiers.NameCell
    } else if tableColumn == tableView.tableColumns[1] {
      text = dateFormatter.string(from: item.date)
      cellIdentifier = CellIdentifiers.DateCell
    } else if tableColumn == tableView.tableColumns[2] {
      text = item.isFolder ? "--" : sizeFormatter.string(fromByteCount: item.size)
      cellIdentifier = CellIdentifiers.SizeCell
    }

    if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
      cell.textField?.stringValue = text
      cell.imageView?.image = image ?? nil
      return cell
    }
    return nil
  }

  func tableViewSelectionDidChange(_ notification: Notification) {
    updateStatus()
  }
  
}
