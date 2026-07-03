// pages/Huawei_IOT.js

const domainname = 'bricksburgakataka';
const username = 'Wechat01';
const password = 'lego0369';
const projectId = '2c1b69ce3828429fb0682557f8309123';
const deviceId = '690343cb0a9ab42ae589dd21_CAM01';
const iamhttps = 'iam.cn-east-3.myhuaweicloud.com';
const iotdahttps = '943f583bff.st1.iotda-app.cn-east-3.myhuaweicloud.com';

Page({
    data: {
        activeTab: 'ai',
        deviceSwitch: true,
        currentTime: '',
        isImageLoading: false,
        hasAIResult: false,
        aiResult: '',
        temperature: '',
        humidity: '',
        windScale: '',
        windSpeed: '',
        windDir: '',
        visibility: '',
        condition: '',
        feelLike: '',
        hasScheduleReminder: false,
        countdownString: '',
        scheduleTime: '',
        scheduleTitle: ''
    },

    touchBtn_getshadow: function() {
        this.getshadow();
    },

    touchBtn_takePhoto: function() {
        if (!this.data.deviceSwitch) return;
        this.setData({ isImageLoading: true });
        this.sendTakePhotoCommand();
    },

    sendTakePhotoCommand: function() {
        var that = this;
        var token = wx.getStorageSync('token');
        if (!token) {
            this.setData({ isImageLoading: false });
            return;
        }
        
        console.log('发送拍照命令...');
        
        wx.request({
            url: `https://${iotdahttps}/v5/iot/${projectId}/devices/${deviceId}/commands`,
            data: {
                "service_id": "ESP32CAM01",
                "command_name": "TakePhoto",
                "paras": {
                    "TakePhoto": true
                }
            },
            method: 'POST',
            header: { 
                'content-type': 'application/json', 
                'X-Auth-Token': token 
            },
            success: function(res) {
                console.log('拍照命令发送成功', res);
                // 立即获取状态
                setTimeout(() => {
                    that.getshadow();
                }, 3000);
            },
            fail: function(err) {
                console.log('拍照命令发送失败', err);
                that.setData({ isImageLoading: false });
            }
        });
    },

    gettoken: function() {
        var that = this;
        wx.request({
            url: `https://${iamhttps}/v3/auth/tokens`,
            data: {
                "auth": { 
                    "identity": {
                        "methods": ["password"],
                        "password": {
                            "user": {
                                "name": username,
                                "password": password,
                                "domain": { "name": domainname }
                            }
                        }
                    },
                    "scope": { "project": { "name": "cn-east-3" } }
                }
            },
            method: 'POST',
            header: { 'content-type': 'application/json' },
            success: function(res) {
                var token = res.header['X-Subject-Token'];
                if (token) {
                    wx.setStorageSync('token', token);
                    that.getshadow();
                }
            },
            fail: function(err) {
                console.log('获取token失败', err);
            }
        });
    },

    getshadow: function() {
        var that = this;
        var token = wx.getStorageSync('token');
        if (!token) return;
        
        wx.request({
            url: `https://${iotdahttps}/v5/iot/${projectId}/devices/${deviceId}/shadow`,
            method: 'GET',
            header: { 
                'content-type': 'application/json', 
                'X-Auth-Token': token 
            },
            success: function(res) {
                console.log('获取影子数据:', res.data);
                
                if (res.data && res.data.shadow && res.data.shadow.length > 0) {
                    var properties = res.data.shadow[0].reported.properties;
                    console.log('设备属性:', properties);
                    
                    // 直接设置所有数据
                    that.setData({
                        temperature: properties.Temp || '',
                        humidity: properties.Humidity || '',
                        windScale: properties.WindScale || '',
                        windSpeed: properties.WindSpeed || '',
                        windDir: properties.WindDir || '',
                        visibility: properties.Visibility || '',
                        condition: properties.Condition || '',
                        feelLike: properties.FeelsLike || '',
                        aiResult: properties.AIRresult || properties.AIResult || '',
                        countdownString: properties.CountdownString || '',
                        scheduleTime: properties.ScheduleTime || '',
                        scheduleTitle: properties['Schedule Title'] || properties.ScheduleTitle || '',
                        hasAIResult: !!(properties.AIRresult || properties.AlResult),
                        hasScheduleReminder: !!properties.CountdownString,
                        isImageLoading: false
                    });
                } else {
                    that.setData({ isImageLoading: false });
                }
            },
            fail: function(err) {
                console.log('获取影子失败', err);
                that.setData({ isImageLoading: false });
            }
        });
    },

    sendWeatherUpdateCommand: function() {
        var that = this;
        var token = wx.getStorageSync('token');
        if (!token) return;
        
        wx.request({
            url: `https://${iotdahttps}/v5/iot/${projectId}/devices/${deviceId}/commands`,
            data: {
                "service_id": "ESP32CAM01",
                "command_name": "WeatherUpdate",
                "paras": { "City": "杭州" }
            },
            method: 'POST',
            header: { 
                'content-type': 'application/json', 
                'X-Auth-Token': token 
            },
            success: function(res) {
                setTimeout(() => { that.getshadow(); }, 2000);
            },
            fail: function(err) {
                console.log('天气更新命令失败', err);
            }
        });
    },

    copyAIResult: function() {
        if (this.data.aiResult) {
            wx.setClipboardData({
                data: this.data.aiResult
            });
        }
    },

    clearScheduleReminder: function() {
        this.setData({
            hasScheduleReminder: false
        });
    },

    updateCurrentTime: function() {
        const now = new Date();
        let hours = now.getHours();
        let minutes = now.getMinutes();
        let seconds = now.getSeconds();
        
        hours = hours < 10 ? '0' + hours : hours;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        seconds = seconds < 10 ? '0' + seconds : seconds;
        
        const timeString = `${hours}:${minutes}:${seconds}`;
        this.setData({
            currentTime: timeString
        });
    },

    switchTab: function(e) {
        const tab = e.currentTarget.dataset.tab;
        this.setData({
            activeTab: tab
        });
    },

    onLoad(options) {
        this.gettoken();
        this.updateCurrentTime();
        
        this.dataInterval = setInterval(() => {
            this.getshadow();
        }, 5000);
        
        this.timeInterval = setInterval(() => {
            this.updateCurrentTime();
        }, 1000);
    },

    onUnload() {
        if (this.dataInterval) clearInterval(this.dataInterval);
        if (this.timeInterval) clearInterval(this.timeInterval);
    }
})