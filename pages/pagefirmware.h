/*
    Copyright 2016 - 2017 Benjamin Vedder	benjamin@vedder.se

    

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program .  If not, see <http://www.gnu.org/licenses/>.
    */

#ifndef PAGEFIRMWARE_H
#define PAGEFIRMWARE_H

#include <QWidget>
#include "vescinterface.h"

namespace Ui {
class PageFirmware;
}

class PageFirmware : public QWidget
{
    Q_OBJECT

public:
    explicit PageFirmware(QWidget *parent = 0);
    ~PageFirmware();

    VescInterface *vesc() const;
    void setVesc(VescInterface *vesc);

private slots:
    void fwUploadStatus(const QString &status, double progress, bool isOngoing);
    void fwVersionReceived(int major, int minor, QString hw, QByteArray uuid);
    void updateHwList(QString hw = "");
    void updateFwList();
    void updateBlList(QString hw = "");

    void on_chooseButton_clicked();
    void on_uploadButton_clicked();
    void on_readVersionButton_clicked();
    void on_cancelButton_clicked();
    void on_changelogButton_clicked();

private:
    Ui::PageFirmware *ui;
    VescInterface *mVesc;

};

#endif // PAGEFIRMWARE_H
