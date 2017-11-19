#!/bin/bash

#set -x

if [[ -v RO_SHARES ]]; then
    for share in $RO_SHARES
    do
        IFS=':' read local remote <<< "$share"
        if [[ -z $remote ]]; then
            remote=$local
            local=/mnt/`basename $local`
        fi
        echo Mounting $remote as $local - read-only
        mkdir -p $local
        if [[ -z "$RO_PASSWORD" ]]; then
            mount -v -t cifs -o user=$RO_USERNAME,ro,guest,dir_mode=0777,file_mode=0777,serverino $remote $local
        else
            mount -v -t cifs -o user=$RO_USERNAME,ro,password="$RO_PASSWORD",dir_mode=0777,file_mode=0777,serverino $remote $local
        fi
    done
fi

if [[ -v RW_SHARES ]]; then
    for share in $RW_SHARES
    do
        IFS=':' read local remote <<< "$share"
        if [[ -z $remote ]]; then
            remote=$local
            local=/mnt/`basename $local`
        fi
        echo Mounting $remote as $local - writable
        mkdir -p $local
        if [[ -z "$RW_PASSWORD" ]]; then
            mount -v -t cifs -o user=$RW_USERNAME,ro,guest,dir_mode=0777,file_mode=0777,serverino $remote $local
        else
            mount -v -t cifs -o user=$RW_USERNAME,ro,password="$RW_PASSWORD",dir_mode=0777,file_mode=0777,serverino $remote $local
        fi
    done
fi

sleep infinity
